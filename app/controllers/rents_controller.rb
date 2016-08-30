class RentsController < ApplicationController
 
  before_action :authenticate_user! , except: [:index]
  before_action :set_rent , only: [:show , :edit ,:update,:destroy]
  require 'rest-client'
  require 'json'

  @@api_token = '7411169a651e1910e7f007c2530de6ec0594a26cd27619c3e80e8836b6456505f1e891a0f5bd3a0db1988beee701be2f5ad79e4d81f57eb2d69301584374e88d'

  def index
    @rent_calendar_url = 'rr7j9s4d5k21c4bcicn50ccpv8@group.calendar.google.com'   
  end

  def search
    @rent=Rent.where(user_id: current_user.id)
    url = 'http://140.115.3.188/facility/v1/facility/6'
    api=RestClient.put(url, {:access_token => ENV['access_token'],:id => '6', :name =>'I002' , :description => 'I002'})

  end
 
  def show
  
  end

  def edit

  end
  
  def update

  end

  def destroy
    puts @rent.apid
    url = 'http://140.115.3.188/facility/v1/facility/rent'+@rent.apid.to_s
    api = RestClient.delete(url , { :Authorization => ENV['access_token'] , 'id' => @rent.apid.to_s})
    @rent.destroy
  end


  def new 
    @rent=Rent.new
  end

  def create
    @rent = Rent.new(params_rent)
    @rent.user_id = current_user.id
    @rent.status = "待審核" 
    url = 'http://140.115.3.188/facility/v1/facility/'+@rent.facility.to_s+'/rent'
    rent = params[:rent]
    start = DateTime.new(rent["start(1i)"].to_i ,rent["start(2i)"].to_i ,rent["start(3i)"].to_i ,rent["start(4i)"].to_i, rent["start(5i)"].to_i)
    endt = DateTime.new(rent["end(1i)"].to_i ,rent["end(2i)"].to_i ,rent["end(3i)"].to_i ,rent["end(4i)"].to_i, rent["end(5i)"].to_i)

    data = [
      {
    	:start => start,
        :end => endt 
      }
    ]
    jdata=data.to_json
    api = RestClient.post(url,
    {
      :name => @rent.name,
      :spans => jdata,
      :access_token => ENV['access_token']
    })
    japi=JSON.parse(api)
    puts japi["id"]
    @rent.apid = japi["id"].to_i
    @rent.save
    redirect_to rent_print_path 
  end
  

  def print
    

  end


  private
  def set_rent
    @rent=Rent.find(params[:id])
  end

  def params_rent
    params.require(:rent).permit(:facility,:name,:start,:end)

  end

end
