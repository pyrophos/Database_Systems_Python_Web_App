from os import abort

__author__ = 'RR1'

from flask import Flask, render_template, redirect, url_for, request, session, flash, escape
from data import queries, follows, reviews
from flask import render_template
from data import user_lists, activity
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
            u_name = session['username']
            with easypg.cursor() as cur:
                session['user_id'] = queries.get_user_id(cur, u_name)
            return render_template('user_main_page.html',
                                   uid = u_name
                                  )
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

@app.route('/main', methods=['GET', 'POST'])
def home():
    if request.method == 'GET':
        return render_template('user_main_page.html')

    if request.method == 'POST':
        return redirect('/search')





@app.route('/users/<uid>/lists')
def get_series_list(uid):
    with easypg.cursor() as cur:
        id = session['user_id']
        u_list = user_lists.get_all_user_list(cur, id )
    return render_template('user_list.html', uid=uid, list = u_list)

@app.route('/users/<uid>/lists/add_list')
def get_add_list(uid):
    return render_template('add_list_page.html', uid=uid)


@app.route('/users/<uid>/lists/add', methods=['POST', 'GET'])
def add_list(uid):
    title = request.form['title']
    text = request.form['description']
    is_public = request.form['public']
    if is_public != 'f':
        is_public = 't'

    print is_public
    app.logger.info('list details  %s: %s', title, text )
    with easypg.cursor() as cur:
        id = session['user_id']
        user_lists.add_list(cur, id, title, text, is_public)
    # redirect user back to article which will display comments
    # always redirect after a POST
    return redirect('/users/' + uid + '/lists')

@app.route('/users/<uid>/lists/<list_id>', methods=['POST', 'GET'])
def edit_list(uid, list_id):
    if request.method == "GET":
        with easypg.cursor() as cur:
            list_books = user_lists.get_books_in_list(cur, list_id)

        #if list_books is None:
          #  abort(404)

        return render_template('edit_list.html',
                                    uid=uid,
                                     l_id=list_id,
                                     list_books = list_books)

@app.route('/users/<uid>/lists/delete_list/<list_id>', methods=['POST', 'GET'])
def delete_list(list_id, uid):
    with easypg.cursor() as cur:
        user_lists.delete_list(cur, list_id)

    return redirect('/users/' + uid + '/lists')


@app.route('/search')
def get_search_results():
    if 'q' in request.args:
        query = request.args['q']
    if 'dropdown' in request.args:
        type = request.args['dropdown']
    else:
        abort(400)

    books = None
    authors = None
    categories = None
    users = None

    with easypg.cursor() as cur:
        if type == "Book":
            books = queries.search_titles(cur, query)
        if type == "Author":
            authors = queries.search_authors(cur, query)
        if type == "Categories":
            categories = queries.search_categories(cur, query)
        if type == "User":
            users = queries.search_users(cur, query)


    return render_template('search_results.html',
                           query=query,
                           books=books,
                           users=users,
                           authors=authors,
                           categories=categories)

@app.route('/followers/<uid>')
def print_followers(uid):
    if 'page' in request.args:
        page = int(request.args['page'])
    else:
        page = 1
    if page <= 0:
        abort(404)

    id = session['username']
    with easypg.cursor() as cur:
        followers = follows.get_followers(cur, page, id)
        total_pages = follows.get_follower_pg_cnt(cur, id)
        return render_template('followers.html',
                                     follow = followers,
                                     page = page,
                                     total_pages = total_pages,
                                     user = id
                                     )
    if page > 1:
        prevPage = page - 1
    else:
        prevPage = None
    if page < total_pages:
        nextPage = page + 1
    else:
        nextPage = None

@app.route('/follows/<user_id>', methods=['GET'])
def print_followees(user_id):
    if request.method == "GET":
        if 'page' in request.args:
            page = int(request.args['page'])
        else:
            page = 1
        if page <= 0:
            abort(404)

        with easypg.cursor() as cur:
            followees = follows.get_followees(cur, page, user_id)
            total_pages = follows.get_followee_pg_cnt(cur, user_id)
            return render_template('followees.html',
                                         follow = followees,
                                         page = page,
                                         total_pages = total_pages,
                                         uid = user_id
                                        )

        if page > 1:
            prevPage = page - 1
        else:
            prevPage = None
        if page < total_pages:
            nextPage = page + 1
        else:
            nextPage = None

@app.route('/follows/<user_id>/delete', methods=['POST'])
def unfollow_from_frinds_list(user_id):
    f = request.form
    for key in f.keys():
        remove_follower = f.getlist(key)[0]
    if request.method == "POST":
        with easypg.cursor() as cur:
            #remove_follower = request.form['unfollow']
            follows.unfollow(cur, session['username'], remove_follower)
        return redirect('/follows/' + user_id)

@app.route('/users/<uid>')
def user_page(uid):
    with easypg.cursor() as cur:
        following = follows.get_follow_status(cur, session['username'], uid)
    return render_template('user_main_page.html',
                                 uid = uid,
                                 following = following
                                )

@app.route('/users/<uid>/follow', methods=['POST'])
def follow_user(uid):
    with easypg.cursor() as cur:
        username = session['username']
        user_to_follow = queries.get_user_id(cur, username)
        follows.follow_user(cur, session['user_id'], user_to_follow)
    return redirect('/users/' + uid)

@app.route('/users/<uid>/unfollow', methods=['POST'])
def unfollow_from_user_page(uid):
    f = request.form
    for key in f.keys():
        remove_follower = f.getlist(key)[0]
    with easypg.cursor() as cur:
        follows.unfollow(cur, session['username'], remove_follower)
    return redirect('/users/' + uid)

@app.route('/users/<uid>/reviews')
def get_review_list(uid):
    if 'page' in request.args:
        page = int(request.args['page'])
    else:
        page = 1
    if page <= 0:
        abort(404)

    with easypg.cursor() as cur:
        review_list = reviews.get_reviews_list(cur, uid)
        num_pages   = reviews.get_reviews_pg_cnt(cur, uid)
    return render_template('review_list.html',
                                 review_list = review_list,
                                 page = page,
                                 num_pages = num_pages,
                                 uid = uid)

@app.route('/reviews/<uid>/<rid>')
def get_review(uid, rid):
    with easypg.cursor() as cur:
        review_info = reviews.get_user_review(cur, rid)
        author_list = reviews.get_author_names(cur, rid)
        num_likes   = reviews.get_likes(cur, rid, session['user_id'])
    return render_template('review_text.html',
                                 uid = uid,
                                 author_list = author_list,
                                 num_likes = num_likes,
                                 **review_info
                                 )

@app.route('/reviews/<uid>/<rid>/delete', methods=['POST'])
def dlt_review(uid, rid):
    with easypg.cursor() as cur:
        f = request.form
        for key in f.keys():
            remove_review = f.getlist(key)[0]
        reviews.delete_review(cur, remove_review)
    return redirect('/users/' + uid + '/reviews')

@app.route('/reviews/<uid>/<review_id>/like', methods=['POST'])
def lk_review(uid, review_id):
    with easypg.cursor() as cur:
        f = request.form
        for key in f.keys():
            like_review = f.getlist(key)[0]
        reviews.like_review(cur, review_id, session['user_id'])
    return redirect('/reviews/' + uid + '/' + review_id)

@app.route('/reviews/<uid>/<review_id>/unlike', methods=['POST'])
def unlk_review(uid, review_id):
    with easypg.cursor() as cur:
        f = request.form
        for key in f.keys():
            unlike_review = f.getlist(key)[0]
        reviews.unlike_review(cur, review_id, session['user_id'])
    return redirect('/reviews/' + uid + '/' + review_id)

@app.route('/author/<id>', methods=['POST', 'GET'])
def authors_search_results(id):
    with easypg.cursor() as cur:
        details = queries.get_author_books(cur, id)

    return render_template('author_details.html', details=details)

@app.route('/users/<uid>/friend_activity')
def get_frnd_actvty(uid):
    with easypg.cursor() as cur:
        user_id = queries.get_user_id(cur, uid)
        activity_info = activity.get_friend_activity(cur, user_id)
    return render_template('activity_list.html',
                           activity_info = activity_info,
                           uid = uid)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
