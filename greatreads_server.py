from os import abort

__author__ = 'RR1'

from flask import Flask, render_template, redirect, url_for, request, session, flash, escape
from data import queries
from flask import render_template
from data import user_lists
import os
import easypg

app = Flask('greatreads_server')
app.secret_key = os.urandom(24)

@app.route('/login', methods=['GET', 'POST'])
def login():
    """
    User login page.

    :return:
    """
    if request.method == 'POST':
        if queries.compare_unpw(request.form['username'], request.form['password']):
            session['username'] = request.form['username']
            return render_template('user_main_page.html')
        else:
            error = 'Invalid Credentials. Please try again.'
            return render_template('login.html', error=error)

    if request.method == 'GET':
        return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    """
    This is the registration page, its

    :return:
    if method is POST, then add the user and return to login.
    if method is GET, then show the registration page.
    """
    if request.method == 'GET':
        return render_template('register.html')

    if request.method == 'POST':
        usr_name = request.form['username']
        usr_pw = request.form['password']
        usr_email = request.form['email']
        with easypg.cursor() as cur:
            queries.add_user(cur, usr_name, usr_pw, usr_email)
        return render_template('login.html')


@app.route('/logout',  methods=['GET'])
def logout():
    """
    Logout the user session.

    :return:
    """
    if request.method == 'GET':
        # remove the username from the session if it's there
        session.pop('logged_in', None)
        flash('You were logged out')
        return redirect('/login')

@app.route('/main')
def home():
    return render_template('user_main_page.html')


@app.route('/lists')
def get_series_list():
    with easypg.cursor() as cur:
        u_list = user_lists.get_all_user_list(cur,1 )
        return render_template('user_list.html', list = u_list)

@app.route('/lists/add_list')
def get_add_list():
    return render_template('add_list_page.html')


@app.route('/lists/add_list/add', methods=['POST', 'GET'])
def add_list():
    title = request.form['title']
    text = request.form['description']
    is_public = request.form['public']
    if is_public != 'f':
        is_public = 't'

    print is_public
    app.logger.info('list details  %s: %s', title, text )
    with easypg.cursor() as cur:
        user_lists.add_list(cur, 1, title, text, is_public)
    # redirect user back to article which will display comments
    # always redirect after a POST
    return redirect('/lists')

@app.route('/lists/<list_id>', methods=['POST', 'GET'])
def edit_list(list_id):
    with easypg.cursor() as cur:
        list_books = user_lists.get_books_in_list(cur, 3)

    #if list_books is None:
      #  abort(404)

    return render_template('edit_list.html',
                                 l_id=list_id,
                                 list_books = list_books)

@app.route('/lists/delete_list/<list_id>', methods=['POST', 'GET'])
def delete_list(list_id):
    with easypg.cursor() as cur:
        user_lists.delete_list(cur, list_id)

    return redirect('/lists')


@app.route('/search')
def get_search_results():
    if 'q' in request.args:
        query = request.args['q']
    else:
        abort(400)

    with easypg.cursor() as cur:
        results = queries.search(cur, query)
    return render_template('search_results.html',
                           query=query,
                           articles=results)


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)