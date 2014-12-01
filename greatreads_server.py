from os import abort

__author__ = 'aponcy'

from flask import Flask, render_template, redirect, url_for, request, session, flash, escape
from data import queries
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
            return render_template('home.html')
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


@app.route('/', methods=['GET', 'POST'])
def home():
    """
    This is a home page placeholder.

    :return:
    """
    if request.method == 'GET':
        if 'username' in session:
            return render_template('home.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)