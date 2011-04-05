class ApiController < ApplicationController
  def index
  end

  def node
    case params["type"]
    when "root"
      render :json => Language.find(:all).
        map{|l| {:type => "language", :text => l.name}}
    when "language"
      render :json => Language.find_by_name(params[:text]).
        categories.find(:all,:conditions => "parent_id is null").
        map{|c| {:type => "category", :text => c.name}}
    when "category"
      category = Category.find_by_name(params[:text])
      result = category.functions.map{|f| {:type => "function", :text => f.name, :leaf => true}}
      result += category.children.map{|c| {:type => "category", :text => c.name}}
      render :json => result
    end
  end

  def show
    case params["type"]
    when "category"
      category = Category.find_by_name(params[:text])
      if category.functions.empty?
        @functions = category.children.map{|c| c.functions}.flatten
      else
        @functions = category.functions
      end
    when "function"
      @functions = Function.find_all_by_name(params[:text])
    when "language"
      @language = Language.find_by_name(params[:text])
      render :action => "language"
    when "function_id"
      # from search form
      @functions = [Function.find(params[:text])]
    end
  end

  def complete
    functions = Function.find(:all, :conditions => ["name like ?",params[:query]+"%"])
    functions = functions.map{|c| {:name => c.name, :type => "api", :id => c.id}}
    render :json => {:success => true, :data => functions}
  end

end
