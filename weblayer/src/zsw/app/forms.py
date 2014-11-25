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
                                         'placeholder': 'Password',
                                         'class': 'form-control',
                                         'required': ''}))


class SignUpForm(forms.Form):
    name = forms.CharField(label='',
                                 widget=forms.TextInput(
                                     attrs={'placeholder': 'Name',
                                            'class': 'form-control',
                                            'required': '',
                                            'autofocus': ''}))
    surname = forms.CharField(label='',
                                    widget=forms.TextInput(
                                        attrs={'placeholder': 'Surname',
                                               'class': 'form-control',
                                               'required': ''}))
    phone = forms.CharField(label='',
                                  widget=forms.TextInput(
                                      attrs={'placeholder': 'Phone',
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
                                             'placeholder': 'Password',
                                             'class': 'form-control',
                                             'required': ''}))


class ApartmentForm(forms.Form):
    name = forms.CharField(label='',
                                 widget=forms.TextInput(
                                     attrs={'placeholder': 'Name',
                                            'class': 'form-control',
                                            'required': ''}))
    address = forms.CharField(label='',
                                    widget=forms.TextInput(
                                        attrs={'placeholder': 'Address',
                                               'class': 'form-control',
                                               'required': ''}))
    city = forms.CharField(label='',
                                 widget=forms.TextInput(
                                     attrs={'placeholder': 'City',
                                            'class': 'form-control',
                                            'required': ''}))
    description = forms.CharField(label='',
                                        widget=forms.TextInput(attrs={
                                            'placeholder': 'Description',
                                            'class': 'form-control',
                                            'required': ''}))


class AddResidentToApartmentForm(forms.Form):
    email = forms.EmailField(label='',
                             widget=forms.TextInput(
                                 attrs={'placeholder': 'Email',
                                        'class': 'form-control',
                                        'required': ''}))

class AddBillToApartmentForm(forms.Form):
    name = forms.CharField(label='',
                            widget=forms.TextInput(attrs={
                                        'placeholder': 'Name',
                                        'class': 'form-control',
                                        'required': ''}))
    description = forms.CharField(label='',
                            widget=forms.TextInput(attrs={
                                        'placeholder': 'Description',
                                        'class': 'form-control',
                                        'required': ''}))
    value = forms.DecimalField(label='', 
                              max_digits=19, 
                              decimal_places=2,
                              widget=forms.TextInput(attrs={
                                        'placeholder': 'Value',
                                        'class': 'form-control',
                                        'required': ''}))
