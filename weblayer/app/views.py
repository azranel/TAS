from django.shortcuts import render, render_to_response
from django.contrib.sessions.backends.db import SessionStore
from app.forms import SignInForm, SignUpForm
import httplib2
import json


SERVER = "http://0.0.0.0:4567/users/"


def check_session(request):
    if 'key' in request.COOKIES:
        session_key = request.COOKIES['key']
        s = SessionStore(session_key=session_key)
        return {'id': s['user_id'],
                'login': s['login']}
    else:
        return {}


def login(request):
    status = check_session(request)
    if request.method == 'POST':
        form = SignInForm(request.POST)
        if form.is_valid():
            form_dict = {
                'login': form.cleaned_data['login'],
                'password': form.cleaned_data['password'],
            }
            body = "email=" + form_dict['login'] + "&password=" + \
                   form_dict['password']

            h = httplib2.Http()
            resp, content = h.request(SERVER + "login",
                                      method="POST",
                                      body=body)
            content = json.loads(content)

            if content['status'] == 200:
                s = SessionStore()
                s['user_id'] = content['id']
                s['login'] = form_dict['login']
                s.save()
                key = s.session_key

                login_data = {
                    'id': content['id'],
                    'login': form_dict['login'],
                }

                response = render(request, 'app/signin.html', {
                                  'login_data': login_data,
                                  })

                response.set_cookie(key='key', value=key)
            else:
                form = SignInForm()
                response = render(request, 'app/signin.html', {
                          'form': form,
                          'login_data': status,
                          'no_access': True
                          })
    else:
        form = SignInForm()
        response = render(request, 'app/signin.html', {
                          'form': form,
                          'login_data': status,
                          })
    return response


def register(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            form_dict = {
                'login': form.cleaned_data['email'],
                'password': form.cleaned_data['password'],
                'name': form.cleaned_data['name'],
                'surname': form.cleaned_data['surname'],
                'phone': form.cleaned_data['phone'],
            }
            body = "user[firstname]=" + form_dict['name'] + \
                "&user[lastname]=" + form_dict['surname'] + \
                "&user[email]=" + form_dict['login'] + \
                "&user[password]=" + form_dict['password'] + \
                "&user[phone]=" + form_dict['phone']

            h = httplib2.Http()
            resp, content = h.request(SERVER + "register",
                                      method="POST",
                                      body=body)
            content = json.loads(content)

            if content['status'] == 200:
                s = SessionStore()
                s['user_id'] = content['id']
                s['login'] = form_dict['login']
                s.save()
                key = s.session_key

                login_data = {
                    'id': content['id'],
                    'login': form_dict['login'],
                }

                response = render(request, 'app/signup.html', {
                                  'login_data': login_data,
                                  })

                response.set_cookie(key='key', value=key)
            else:
                response = render(request, 'app/signup.html', {
                    'content': content,
                    'email_in_use': True,
                })
    else:
        form = SignUpForm()
        response = render(request, 'app/signup.html', {
                          'form': form,
                          })
    return response


def index(request):
    status = check_session(request)
    return render(request, 'app/index.html', {
                  'login_data': status,
                  })


def about(request):
    status = check_session(request)
    return render(request, 'app/about.html', {
                  'login_data': status,
                  })


def contact(request):
    status = check_session(request)
    return render(request, 'app/contact.html', {
                  'login_data': status,
                  })


def signup(request):
    response = register(request)
    return response


def signin(request):
    response = login(request)
    return response


def signout(request):
    response = render_to_response('app/index.html', {
                                  'login_data': {'signout': True}
                                  })
    response.set_cookie(key='key', expires=0)
    return response
