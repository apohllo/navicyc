class ConsoleController < ApplicationController
  layout false
  helper :symbol

  def show
    begin
      @answer = cyc.raw_talk(params[:id])
    rescue Exception => ex
      @answer = ex.to_s
      render :json => @answer, :status => 400
    end
  end

  protected
  def cyc
    CYC
  end
end
