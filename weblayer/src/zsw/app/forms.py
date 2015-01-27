import django.forms as forms


class SignInForm(forms.Form):
    login = forms.EmailField(label='',
                                   widget=forms.TextInput(
                                       attrs={'placeholder': 'Email',
                                              'class': 'form-control',
                                              'required': '',
                                              'autofocus': ''}))
    password = forms.CharField(label='',
                                     widget=forms.PasswordInput(attrs={
                                         'placeholder': 'Haslo',
                                         'class': 'form-control',
                                         'required': ''}))


class SignUpForm(forms.Form):
    name = forms.CharField(label='',
                                 widget=forms.TextInput(
                                     attrs={'placeholder': 'Imie',
                                            'class': 'form-control',
                                            'required': '',
                                            'autofocus': ''}))
    surname = forms.CharField(label='',
                                    widget=forms.TextInput(
                                        attrs={'placeholder': 'Nazwisko',
                                               'class': 'form-control',
                                               'required': ''}))
    phone = forms.CharField(label='',
                                  widget=forms.TextInput(
                                      attrs={'placeholder': 'Telefon',
                                             'class': 'form-control',
                                             'required': ''}))
    email = forms.EmailField(label='',
                                   widget=forms.TextInput(
                                       attrs={'placeholder': 'Email',
                                              'class': 'form-control',
                                              'required': ''}))
    password = forms.CharField(label='',
                                     widget=forms.PasswordInput(
                                         attrs={
                                             'placeholder': 'Haslo',
                                             'class': 'form-control',
                                             'required': ''}))


class ApartmentForm(forms.Form):
    name = forms.CharField(label='',
                                 widget=forms.TextInput(
                                     attrs={'placeholder': 'Imie',
                                            'class': 'form-control',
                                            'required': ''}))
    address = forms.CharField(label='',
                                    widget=forms.TextInput(
                                        attrs={'placeholder': 'Adres',
                                               'class': 'form-control',
                                               'required': ''}))
    city = forms.CharField(label='',
                                 widget=forms.TextInput(
                                     attrs={'placeholder': 'Miasto',
                                            'class': 'form-control',
                                            'required': ''}))
    description = forms.CharField(label='',
                                        widget=forms.TextInput(attrs={
                                            'placeholder': 'Opis',
                                            'class': 'form-control',
                                            'required': ''}))


class AddResidentToApartmentForm(forms.Form):
    email = forms.EmailField(label='',
                             widget=forms.TextInput(
                                 attrs={'placeholder': 'Email',
                                        'class': 'form-control form-group',
                                        'required': ''}))


class BillForm(forms.Form):
    name = forms.CharField(label='',
                           widget=forms.TextInput(attrs={
                               'placeholder': 'Nazwa',
                               'class': 'form-control form-group',
                               'required': ''}))
    description = forms.CharField(label='',
                                  widget=forms.TextInput(attrs={
                                      'placeholder': 'Opis',
                                      'class': 'form-control form-group',
                                      'required': ''}))
    value = forms.DecimalField(label='',
                               max_digits=19,
                               decimal_places=2,
                               widget=forms.TextInput(attrs={
                                   'placeholder': 'Wartosc',
                                   'class': 'form-control form-group',
                                   'required': ''}))


class MessageForm(forms.Form):
    subject = forms.CharField(label='',
                              widget=forms.TextInput(attrs={
                                    'placeholder': 'Temat',
                                    'class': 'form-control form-group',
                                    'required': ''}))
    content = forms.CharField(label='',
                              widget=forms.Textarea(attrs={
                                    'placeholder': 'Wiadomosc',
                                    'class': 'form-control form-group',
                                    'required': ''}))
