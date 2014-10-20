from django.conf.urls import patterns, include, url

from django.contrib import admin
from app import views
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^$', views.index, name='index'),
    url(r'^about', views.about, name='about'),
    url(r'^contact', views.contact, name='contact'),
    url(r'^signup', views.signup, name='signup'),
    url(r'^signin', views.signin, name='signin'),
    url(r'^signout', views.signout, name='signout'),
)
