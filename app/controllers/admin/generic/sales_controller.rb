# Use this model to create 20% off sales for any given product

class Admin::Generic::SalesController < Admin::Generic::BaseController
  helper_method :sort_column, :sort_direction, :products
  def index
    params[:page] ||= 1
    params[:rows] ||= 20
    @sales = Sale.order(sort_column + " " + sort_direction).
                                              paginate(:page => params[:page].to_i, :per_page => params[:rows].to_i)
  end

  def show
    @sale = Sale.find(params[:id])
  end

  def new
    @sale = Sale.new
    form_info
  end

  def create
    @sale = Sale.new(params[:sale])
    if @sale.save
      redirect_to [:admin, :generic, @sale], :notice => "Successfully created sale."
    else
      form_info
      render :new
    end
  end

  def edit
    @sale = Sale.find(params[:id])
    form_info
  end

  def update
    @sale = Sale.find(params[:id])
    if @sale.update_attributes(params[:sale])
      redirect_to [:admin, :generic, @sale], :notice  => "Successfully updated sale."
    else
      form_info
      render :edit
    end
  end

  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy
    redirect_to admin_generic_sales_url, :notice => "Successfully destroyed sale."
  end

  private
    def form_info

    end

    def products
      @products ||= Product.select([:id, :name]).all.map{|p| [p.name, p.id]}
    end

    def sort_column
      Sale.column_names.include?(params[:sort]) ? params[:sort] : "product_id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end