class CkanController < ApplicationController
  def node
    case params[:level]
    when "root"
      items = CKAN::Group.find.map{|g| {:level => "group",
        :text => g.name, :id => g.name}}.sort_by{|e| e[:text]}
    when "group"
      items = CKAN::Group.new(params[:id]).packages.
        map{|p| {:level => "package", :text => p.title, :id => p.id}}.
        sort_by{|e| e[:text]}
    when "package"
      items = CKAN::Package.new(params[:id]).resources.
        map{|r| {:level => "resource", :text => "#{r.description} (#{r.format})",
          :id => "#{params[:id]}##{r.format}", :leaf => true}}.
          sort_by{|e| e[:text]}
    end
    render :json => items
  end

  def show
    case params[:level]
    when "group"
      render :partial => "group", :object => CKAN::Group.new(params[:id])
    when "package"
      render :partial => "package", :object => CKAN::Package.new(params[:id])
    when "resource"
      package, format = params[:id].split("#")
      format = "" if format.nil?
      resource = CKAN::Package.new(package).resources.find{|r| r.format == format}
      render :partial => "resource", :object => resource
    when "package_id"
      render :partial => "package", :object => CKAN::Package.new(params[:text])
    end
  end

  def complete
    packages = CKAN::Package.find(:q => params[:query])
    packages = packages.map{|p| {:name => p.name, :source => "ckan", :id => p.id}}
    render :json => {:success => true, :data => packages}
  end
end
