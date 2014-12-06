# -*- coding: utf-8 -*-

from django.shortcuts import render, render_to_response, HttpResponseRedirect
from django.contrib.sessions.backends.db import SessionStore
import zsw.app.forms as forms
import httplib2
import json


SERVER = "http://0.0.0.0:4567/"


def check_session():
    def get_user(func):
        def wrapper(request, *callback_args, **callback_kwargs):
            if 'key' in request.COOKIES:
                session_key = request.COOKIES['key']
                s = SessionStore(session_key=session_key)
                status = {'id': s['user_id'],
                          'login': s['login']}
            else:
                status = {}
            if len(callback_kwargs):
                return func(request, status, callback_kwargs.values()[0])
            else:
                return func(request, status)
        return wrapper
    return get_user


### USER
@check_session()
def login(request, status):
    if request.method == 'POST':
        form = forms.SignInForm(request.POST)
        if form.is_valid():
            form_dict = {
                'login': form.cleaned_data['login'],
                'password': form.cleaned_data['password'],
            }
            body = "email=" + form_dict['login'] + "&password=" + \
                   form_dict['password']

            h = httplib2.Http()
            resp, content = h.request(SERVER + "users/login",
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

                response = render(request, 'user/signin.html', {
                                  'login_data': login_data,
                                  })

                response.set_cookie(key='key', value=key)
            else:
                form = forms.SignInForm()
                response = render(request, 'user/signin.html', {
                                  'form': form,
                                  'login_data': status,
                                  'no_access': True
                                  })
        else:
            form = forms.SignInForm()
            response = render(request, 'user/signin.html', {
                              'form': form,
                              'login_data': status,
                              'error': form.errors,
                              })
    else:
        form = forms.SignInForm()
        response = render(request, 'user/signin.html', {
                          'form': form,
                          'login_data': status,
                          })
    return response


def fetch(user_id):
    h = httplib2.Http()
    resp, content = h.request(SERVER + "users/" + str(user_id),
                              method="GET")
    content = json.loads(content)
    return content


def register(request):
    if request.method == 'POST':
        form = forms.SignUpForm(request.POST)
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
            resp, content = h.request(SERVER + "users/register",
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

                response = render(request, 'user/signup.html', {
                                  'login_data': login_data,
                                  })

                response.set_cookie(key='key', value=key)
            else:
                response = render(request, 'user/signup.html', {
                    'content': content,
                    'email_in_use': True,
                })
        else:
            form = forms.SignUpForm()
            response = render(request, 'user/signup.html', {
                              'form': form,
                              })
    else:
        form = forms.SignUpForm()
        response = render(request, 'user/signup.html', {
                          'form': form,
                          })
    return response


@check_session()
def user_details(request, status, user_id):
    user_info = fetch(user_id)
    response = render(request, 'user/user_details.html', {
                      'login_data': status,
                      'user_info': user_info,
                      })
    return response


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


### APARTMENTS
def fetch_apartment(apartment_id):
    h = httplib2.Http()
    resp, content = h.request(SERVER + "apartments/" + str(apartment_id),
                              method="GET")
    content = json.loads(content)

    return content


def fetch_bill(bill_id):
    h = httplib2.Http()
    resp, content = h.request(SERVER + "bills/" + str(bill_id),
                              method="GET")
    content = json.loads(content)

    return content


def delete_apartment(request, apartment_id):
    h = httplib2.Http()
    resp, content = h.request(SERVER + "apartments/" + str(apartment_id) +
                              "/delete",
                              method="GET")
    content = json.loads(content)

    if content['status'] == 200:
        response = HttpResponseRedirect('/apartments')
    else:
        response = HttpResponseRedirect('/apartments/' + apartment_id)

    return response


def get_list_of_owned_apartments(request, status):
    user_info = fetch(status['id'])

    return user_info.get('owned')


def get_list_of_ressident_apartments(request, status):
    user_info = fetch(status['id'])

    return user_info.get('apartments')


@check_session()
def apartments(request, status):
    if status != {}:
        list_of_owned_apartments = get_list_of_owned_apartments(
            request,
            status
        )
        list_of_resident_apartments = get_list_of_ressident_apartments(
            request,
            status
        )
    else:
        list_of_owned_apartments = []
        list_of_resident_apartments = []
    return render(request, 'apartments/apartments.html', {
                  'login_data': status,
                  'list_of_owned_apartments': list_of_owned_apartments,
                  'list_of_resident_apartments': list_of_resident_apartments,
                  })


@check_session()
def apartment_details(request, status, apartment_id):
    if request.method == 'POST':
        form_resident = forms.AddResidentToApartmentForm(request.POST)
        form_bill = forms.BillForm(request.POST)
        if form_resident.is_valid():
            form_dict = {
                'email': form_resident.cleaned_data['email'],
            }
            body = "user_id=" + str(status['id']) + \
                "&email=" + form_dict['email']

            h = httplib2.Http()
            resp, content = h.request(SERVER + "apartments/" +
                                      apartment_id + "/addresident",
                                      method="POST",
                                      body=body)
            content = json.loads(content)

            apartment = fetch_apartment(apartment_id)
            response = render(request, 'apartments/apartment_details.html', {
                              'login_data': status,
                              'apartment': apartment,
                              'form_resident': form_resident,
                              'form_bill': forms.BillForm()
                              })
        elif form_bill.is_valid():
            form_dict = {
                'name': form_bill.cleaned_data['name'],
                'description': form_bill.cleaned_data['description'],
                'value': str(form_bill.cleaned_data['value']),
            }

            body = "bill[user_id]=" + str(status['id']) + \
                "&bill[name]=" + form_dict['name'] + \
                "&bill[description]=" + form_dict['description'] + \
                "&bill[value]=" + form_dict['value'] + \
                "&bill[apartment_id]=" + apartment_id

            h = httplib2.Http()
            resp, content = h.request(SERVER + "bills/create",
                                      method="POST",
                                      body=body)
            content = json.loads(content)

            apartment = fetch_apartment(apartment_id)
            response = render(
                request, 'apartments/apartment_details.html', {
                         'login_data': status,
                         'apartment': apartment,
                         'form_resident': forms.AddResidentToApartmentForm(),
                         'form_bill': form_bill
                })
        else:
            form_resident = forms.AddResidentToApartmentForm()
            form_bill = forms.BillForm()
            apartment = fetch_apartment(apartment_id)
            response = render(request, 'apartments/apartment_details.html', {
                              'login_data': status,
                              'apartment': apartment,
                              'form_resident': form_resident,
                              'form_bill': form_bill
                              })
    else:
        form_resident = forms.AddResidentToApartmentForm()
        form_bill = forms.BillForm()
        apartment = fetch_apartment(apartment_id)
        response = render(request, 'apartments/apartment_details.html', {
                          'login_data': status,
                          'apartment': apartment,
                          'form_resident': form_resident,
                          'form_bill': form_bill
                          })
    return response


def delete_bill(request, bill_id):
    h = httplib2.Http()
    resp, content = h.request(SERVER + "bills/" + str(bill_id),
                              method="DELETE")

    response = HttpResponseRedirect('/apartments')

    return response


@check_session()
def edit_bill(request, status, bill_id):
    if request.method == 'POST':
        form = forms.BillForm(request.POST)
        if form.is_valid():
            form_dict = {
                'name': form.cleaned_data['name'],
                'value': form.cleaned_data['value'],
                'description': form.cleaned_data['description']
            }

            bodystr = "bill[name]=" + form_dict['name'] + \
                      "&bill[description]=" + form_dict['description'] + \
                      "&bill[value]=" + str(form_dict['value'])

            print bodystr

            h = httplib2.Http()
            resp, content = h.request(SERVER + "bills/" + bill_id + "/edit",
                                      method="POST",
                                      body=bodystr)
            # content = json.loads(content)
            response = HttpResponseRedirect('/apartments/')

    else:
        bill_info = fetch_bill(bill_id)
        form = forms.BillForm({
            'name': bill_info['name'],
            'value': bill_info['value'],
            'description': bill_info.get('description')})
        response = render(request, 'bills/edit_bill.html', {
                          'form': form,
                          'login_data': status,
                          })

    return response


@check_session()
def edit_apartment(request, status, apartment_id):
    if request.method == 'POST':
        form = forms.ApartmentForm(request.POST)
        if form.is_valid():
            form_dict = {
                'name': form.cleaned_data['name'],
                'address': form.cleaned_data['address'],
                'city': form.cleaned_data['city'],
                'description': form.cleaned_data['description']
            }

            body = "apartment[name]=" + form_dict['name'] + \
                   "&apartment[address]=" + form_dict['address'] + \
                   "&apartment[city]=" + form_dict['city'] + \
                   "&apartment[description]=" + form_dict['description']

            h = httplib2.Http()
            resp, content = h.request(SERVER + "apartments/" + apartment_id +
                                      "/update",
                                      method="POST",
                                      body=body)
            content = json.loads(content)

            if content['status'] == 200:
                response = HttpResponseRedirect('/apartments/' +
                                                str(apartment_id))
            else:
                apartment_info = fetch_apartment(apartment_id)
                form = forms.ApartmentForm({
                    'name': apartment_info['name'],
                    'address': apartment_info['address'],
                    'city': apartment_info['city'],
                    'description': apartment_info.get('description')})
                response = render(request, 'apartments/edit_apartment.html', {
                                  'form': form,
                                  'login_data': status,
                                  })
    else:
        apartment_info = fetch_apartment(apartment_id)
        form = forms.ApartmentForm({
            'name': apartment_info['name'],
            'address': apartment_info['address'],
            'city': apartment_info['city'],
            'description': apartment_info.get('description')})
        response = render(request, 'apartments/edit_apartment.html', {
                          'form': form,
                          'login_data': status,
                          })
    return response


@check_session()
def create_apartment(request, status):
    if request.method == 'POST':
        form = forms.ApartmentForm(request.POST)
        if form.is_valid():
            form_dict = {
                'name': form.cleaned_data['name'],
                'address': form.cleaned_data['address'],
                'city': form.cleaned_data['city'],
                'owner_id': status['id'],
                'description': form.cleaned_data['description']
            }

            body = "apartment[name]=" + form_dict['name'] + \
                   "&apartment[address]=" + form_dict['address'] + \
                   "&apartment[city]=" + form_dict['city'] + \
                   "&apartment[user_id]=" + str(form_dict['owner_id']) + \
                   "&apartment[description]=" + form_dict['description']

            h = httplib2.Http()
            resp, content = h.request(SERVER + "apartments/create",
                                      method="POST",
                                      body=body)
            content = json.loads(content)

            if content['status'] == 200:
                response = HttpResponseRedirect('/apartments')
            else:
                response = render(request, 'apartments/create_apartment.html',
                                  {
                                      'login_data': status,
                                      'content': content,
                                  })
    else:
        form = forms.ApartmentForm()
        response = render(request, 'apartments/create_apartment.html', {
                          'form': form,
                          'login_data': status,
                          })
    return response


### APP
@check_session()
def index(request, status):
    return render(request, 'app/index.html', {
                  'login_data': status,
                  })


@check_session()
def about(request, status):
    return render(request, 'app/about.html', {
                  'login_data': status,
                  })


@check_session()
def contact(request, status):
    return render(request, 'app/contact.html', {
                  'login_data': status,
                  })
