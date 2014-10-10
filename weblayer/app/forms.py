from django.forms import CharField, EmailField, Form, PasswordInput, TextInput


class SignInForm(Form):
    login = EmailField(label='',
                       widget=TextInput(attrs={'placeholder': 'Email',
                                               'class': 'form-control',
                                               'required': '',
                                               'autofocus': ''}))
    password = CharField(label='', widget=PasswordInput(attrs={
        'placeholder': 'Haslo',
        'class': 'form-control',
        'required': ''}))


class SignUpForm(Form):
    imie = CharField(label='',
                     widget=TextInput(attrs={'placeholder': 'Imie',
                                             'class': 'form-control',
                                             'required': '',
                                             'autofocus': ''}))
    nazwisko = CharField(label='',
                     widget=TextInput(attrs={'placeholder': 'Nazwisko',
                                             'class': 'form-control',
                                             'required': ''}))
    adres = CharField(label='',
                     widget=TextInput(attrs={'placeholder': 'Adres',
                                             'class': 'form-control',
                                             'required': ''}))
    email = EmailField(label='',
                       widget=TextInput(attrs={'placeholder': 'Email',
                                               'class': 'form-control',
                                               'required': ''}))
    password = CharField(label='', widget=PasswordInput(attrs={
        'placeholder': 'Haslo',
        'class': 'form-control',
        'required': ''}))
