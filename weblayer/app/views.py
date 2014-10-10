from django.http import HttpResponseRedirect
from django.shortcuts import render
from app.forms import SignInForm, SignUpForm


def index(request):
    if request.method == 'POST':
        form = SignInForm(request.POST)
        if form.is_valid():
            return HttpResponseRedirect('/thanks/')
    else:
        form = SignInForm()

    return render(request, 'app/index.html', {
        'form': form,
    })


def about(request):
    return render(request, 'app/about.html')


def contact(request):
    return render(request, 'app/contact.html')


def signup(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            return HttpResponseRedirect('/thanks/')
    else:
        form = SignUpForm()

    return render(request, 'app/signup.html', {
        'form': form,
    })
