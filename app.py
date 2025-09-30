from pyexpat.errors import messages

from flask import Flask, render_template, request, redirect, url_for, flash
import datetime
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'MySecretKey')

"""In memory storage"""
messages = []

@app.route('/')
def index():
    return render_template('index.html',
                           current_time=datetime.datetime.now(),
                           messages=messages)

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/add_message', methods=['POST'])
def add_message():
    name = request.form.get('name', '').strip()
    message = request.form.get('message', '').strip()

    if name and message:
        messages.append({
            'message':message,
            'name':name,
            'time':datetime.datetime.now().strftime('%d/%m/%Y %H:%M:%S')
        })
        flash('Message added successfully!', category='success')
    else:
        flash('Please enter a name and message', category='error')

    return redirect(url_for('index'))

@app.route('/clear')
def clear():
    messages.clear()
    flash('Message cleared!', category='success')
    return redirect(url_for('index'))

if __name__ == '__main__':
    host = os.environ.get('IP', '0.0.0.0')
    port = int(os.environ.get('PORT', 6546))
    debug = os.environ.get('DEBUG', False)
    app.run(debug=debug, host=host, port=port)