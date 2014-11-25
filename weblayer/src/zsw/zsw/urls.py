from django.conf.urls import patterns, include, url

from django.contrib import admin
from zsw.app import views
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^$', views.index, name='index'),
    url(r'^about', views.about, name='about'),
    url(r'^contact', views.contact, name='contact'),
    url(r'^signup', views.signup, name='signup'),
    url(r'^signin', views.signin, name='signin'),
    url(r'^signout', views.signout, name='signout'),
    url(r'^user/(?P<user_id>[0-9]*)', views.user_details, name='user_details'),
    url(r'^apartments/$', views.apartments, name='apartments'),
    url(r'^apartments/create', views.create_apartment,
        name='create_apartment'),
    url(r'^apartments/(?P<apartment_id>[0-9]*)', views.apartment_details,
        name='apartment_details'),
)
