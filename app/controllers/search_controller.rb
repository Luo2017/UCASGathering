class SearchController < ApplicationController
  before_action :validate_search_key
  def index
      if @query_string.present?
        @search_result = Activity.ransack(@search_criteria).result(distinct: true) 
      #   @activities = @search_result.paginate(:page => params[:page], :per_page => 15)
        @activities = @search_result
      else
        @activities = Activity.all
      end
      render "static_pages/help"
  end
  protected
  def validate_search_key
      @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
      puts "@query_string:#{@query_string}" 
      @search_criteria = search_criteria(@query_string)
  end
  # 是ransack提供的方法 意思是說，搜尋這個 model 裡面的 title 或是 description 欄位
  def search_criteria(query_string)
    puts "我在执行search_criteria函数"
      { :AcTitle_cont => query_string } 
  end

end
