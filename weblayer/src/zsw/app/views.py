# -*- coding: utf-8 -*-

from django.shortcuts import render, render_to_response, HttpResponseRedirect
from django.contrib.sessions.backends.db import SessionStore
from zsw.zsw import settings
import zsw.app.forms as forms
import httplib2
import json


def check_session():
    """
    Check if user is logged in.
    Return dict of user id and login or empty dict.
    """
    def get_user(func):
        def wrapper(request, *callback_args, **callback_kwargs):
            if 'key' in request.COOKIES:
                session_key = request.COOKIES['key']
                s = SessionStore(session_key=session_key)
                user_data = fetch(s['user_id'])
                status = {'id': s['user_id'],
                          'login': s['login'],
                          'bills': user_data['list_of_apartments']}
            else:
                status = {}
            if len(callback_kwargs):
                return func(request, status, callback_kwargs.values()[0])
            else:
                return func(request, status)
        return wrapper
    return get_user


def request_server(path, method, body):
    """
    Send request to the server.
    Return dict.
    """
    h = httplib2.Http()
    _, content = h.request(
        settings.SERVER + path,
        method=method,
        body=body
    )
    content = json.loads(content)

    return content


### USER
@check_session()
def login(request, status):
    """ Sign in form """
    if request.method == 'POST':
        form = forms.SignInForm(request.POST)
        if form.is_valid():
            form_dict = {
                'login': form.cleaned_data['login'],
                'password': form.cleaned_data['password'],
            }
            body = "email=" + form_dict['login'] + "&password=" + \
                   form_dict['password']
            content = request_server("users/login", "POST", body)

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
    """
    Fetch user data by id from server.
    Return dict.
    """
    return request_server("users/" + str(user_id), "GET", "")


def register(request):
    """ Sign up form """
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
            content = request_server("users/register", "POST", body)

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
    """ View of user details. """
    user_info = fetch(user_id)
    response = render(request, 'user/user_details.html', {
                      'login_data': status,
                      'user_info': user_info,
                      })
    return response


def signup(request):
    """ View of sign up form. """
    response = register(request)
    return response


def signin(request):
    """ View of sign in form. """
    response = login(request)
    return response


def signout(request):
    """ View of sign out form. """
    response = render_to_response('app/index.html', {
                                  'login_data': {'signout': True}
                                  })
    response.set_cookie(key='key', expires=0)
    return response


### APARTMENTS
def fetch_apartment(apartment_id):
    """
    Fetch apartment data by id from server.
    Return dict.
    """
    return request_server("apartments/" + str(apartment_id), "GET", "")


def fetch_bill(bill_id):
    """
    Fetch bill data by id from server.
    Return dict.
    """
    return request_server("bills/" + str(bill_id), "GET", "")


def delete_apartment(request, apartment_id):
    """ Delete apartment by id in server database. """
    content = request_server(
        "apartments/" + str(apartment_id) + "/delete", "GET", ""
    )

    if content['status'] == 200:
        response = HttpResponseRedirect('/apartments')
    else:
        response = HttpResponseRedirect('/apartments/' + apartment_id)

    return response


def get_lists_of_apartments(request, status):
    """ Get lists of owned and ressident apartments. """
    user_info = fetch(status['id'])

    return user_info.get('owned'), user_info.get('apartments')


@check_session()
def apartments(request, status):
    """ View of all assigned apartments. """
    if status != {}:
        owned_apartments, resident_apartments = get_lists_of_apartments(
            request,
            status
        )
    else:
        owned_apartments = []
        resident_apartments = []
    return render(request, 'apartments/apartments.html', {
                  'login_data': status,
                  'list_of_owned_apartments': owned_apartments,
                  'list_of_resident_apartments': resident_apartments,
                  })


def add_resident(request, form_resident, status, apartment_id):
    """ Send request to add resident. """
    form_dict = {
        'email': form_resident.cleaned_data['email'],
    }
    body = "user_id=" + str(status['id']) + \
        "&email=" + form_dict['email']
    request_server(
        "apartments/" + apartment_id + "/addresident",
        "POST",
        body
    )

    apartment = fetch_apartment(apartment_id)

    return render(request, 'apartments/apartment_details.html', {
        'login_data': status,
        'apartment': apartment,
        'form_resident': form_resident,
        'form_bill': forms.BillForm()
    })


def delete_user_from_bill(request, bill_id, debtor_id):
    """ Send request to remove debtor from the bill. """
    content = request_server(
        "bills/" + str(bill_id) + "/deletedebtor",
        "POST",
        "debtor_id=" + str(debtor_id)
    )
    response = HttpResponseRedirect(
        '/apartments/' + str(content['apartment_id'])
    )

    return response


def add_user_to_bill(request, bill_id, debtor_ids):
    """ Send request to add debtor to the bill. """
    body = "user_ids_list=" + debtor_ids

    content = request_server(
        "bills/" + str(bill_id) + "/adddebtors",
        "POST",
        body
    )
    response = HttpResponseRedirect(
        '/apartments/' + str(content['apartment_id'])
    )

    return response


def add_users_list_to_bill(request, bill_id, debtors):
    """ Send request to add list of debtors to the bill. """
    list_of_debtors = [str(debtor['id']) for debtor in debtors]
    return add_user_to_bill(request, bill_id, ",".join(list_of_debtors))


def add_bill(request, status, form_bill, apartment_id):
    """ Send request to add bill. """
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
    content = request_server("bills/create", "POST", body)

    apartment = fetch_apartment(apartment_id)

    return add_users_list_to_bill(
        request,
        content['id'],
        apartment['residents']
    )


@check_session()
def apartment_details(request, status, apartment_id):
    """ View of apartment details. """
    if request.method == 'POST':
        form_resident = forms.AddResidentToApartmentForm(request.POST)
        form_bill = forms.BillForm(request.POST)
        if form_resident.is_valid():
            response = add_resident(
                request,
                form_resident,
                status,
                apartment_id
            )

        elif form_bill.is_valid():
            response = add_bill(request, status, form_bill, apartment_id)

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
    """ Delete bill by id from the server database. """
    content = request_server("bills/" + str(bill_id), "DELETE", "")
    response = HttpResponseRedirect(
        '/apartments/' + str(content['apartment_id'])
    )

    return response


@check_session()
def edit_bill(request, status, bill_id):
    """ View of bill edit form. """
    if request.method == 'POST':
        form = forms.BillForm(request.POST)
        if form.is_valid():
            form_dict = {
                'name': form.cleaned_data['name'],
                'value': form.cleaned_data['value'],
                'description': form.cleaned_data['description']
            }

            body = "bill[name]=" + form_dict['name'] + \
                   "&bill[description]=" + form_dict['description'] + \
                   "&bill[value]=" + str(form_dict['value'])
            content = request_server(
                "bills/" + bill_id + "/edit",
                "POST",
                body
            )
            response = HttpResponseRedirect(
                '/apartments/' + str(content['apartment_id'])
            )

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
    """ View of apartment edit form. """
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
            content = request_server(
                "apartments/" + apartment_id + "/update",
                "POST",
                body
            )
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
    """ View of apartment create form. """
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
            content = request_server("apartments/create", "POST", body)

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
    """ View of main side. """
    return render(request, 'app/index.html', {
                  'login_data': status,
                  })


@check_session()
def about(request, status):
    """ View of about side. """
    return render(request, 'app/about.html', {
                  'login_data': status,
                  })


@check_session()
def contact(request, status):
    """ View of contact side. """
    return render(request, 'app/contact.html', {
                  'login_data': status,
                  })
