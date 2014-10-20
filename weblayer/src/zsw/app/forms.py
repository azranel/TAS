from django.forms import CharField, EmailField, Form, PasswordInput, TextInput


class SignInForm(Form):
    login = EmailField(label='',
                       widget=TextInput(attrs={'placeholder': 'Email',
                                               'class': 'form-control',
                                               'required': '',
                                               'autofocus': ''}))
    password = CharField(label='', widget=PasswordInput(attrs={
        'placeholder': 'Password',
        'class': 'form-control',
        'required': ''}))


class SignUpForm(Form):
    name = CharField(label='',
                     widget=TextInput(attrs={'placeholder': 'Name',
                                             'class': 'form-control',
                                             'required': '',
                                             'autofocus': ''}))
    surname = CharField(label='',
                        widget=TextInput(attrs={'placeholder': 'Surname',
                                                'class': 'form-control',
                                                'required': ''}))
    phone = CharField(label='',
                      widget=TextInput(attrs={'placeholder': 'Phone',
                                              'class': 'form-control',
                                              'required': ''}))
    email = EmailField(label='',
                       widget=TextInput(attrs={'placeholder': 'Email',
                                               'class': 'form-control',
                                               'required': ''}))
    password = CharField(label='', widget=PasswordInput(attrs={
        'placeholder': 'Password',
        'class': 'form-control',
        'required': ''}))
