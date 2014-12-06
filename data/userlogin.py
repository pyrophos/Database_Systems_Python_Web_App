__author__ = 'michael'
#from flask import Flask


import flask
import easypg
from data import authors, books

from flask import render_template

app = flask.Flask('userlogin')

@app.route('/')
def home():
    return flask.render_template('user_main_page.html')


@app.route('/lists')
def get_series_list():
    with easypg.cursor() as cur:
        return flask.render_template('user_list.html')


@app.route('/authors/<aid>')
def get_author(aid):
    with easypg.cursor() as cur:
        info = authors.get_author(cur, aid)

    if info is None:
        flask.abort(404)

    return flask.render_template('authors.html',
                                 author_id=aid,
                                 **info)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)