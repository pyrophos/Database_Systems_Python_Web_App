from flask import Flask


import flask
import easypg

from flask import render_template

app = flask.Flask('userlogin')

@app.route('/')
def home():
    return render_template('user_main_page.html')


@app.route('/lists')
def get_series_list():
    with easypg.cursor() as cur:
        return flask.render_template('user_list.html')

if __name__ == '__main__':
    app.run(debug=True)