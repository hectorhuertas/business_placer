class PlacerController < ApplicationController
  def show
    respond_to do |format|
      format.html {  }
      format.json { {data: "bob"}.to_json }
    end
  end

  def jsoner
    respond_to do |format|
      # format.json { {data: "bob"}.to_json }
      format .json { render :json => {data: "bob"} }
    end
  end
end
