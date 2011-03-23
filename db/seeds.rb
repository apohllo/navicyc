# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Language.create(:name => "SubL LISP",
                :description => "Cyc implementation language",
                :url => "http://www.cyc.com/cycdoc/ref/subl-reference.html")
Language.create(:name => "SubL CORE",
                :description => "SubL core Cyc-related functions",
                :url => "http://www.opencyc.org/doc/opencycapi")

user = User.new(:login => 'admin', :password => 'password',
                :password_confirmation => 'passowrd',
                :email => 'admin@host')
user.save
user.update_attribute(:admin,true)

