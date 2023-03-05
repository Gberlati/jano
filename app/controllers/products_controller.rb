require 'csv'

class ProductsController < ApplicationController
    
    def index
        @products = Product.all
    end

    def show
        @product = Product.find(params[:id])
    end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(product_params)
        
        if @product.save!
            redirect_to @product, notice: 'Product was successfully created.'
        else
            render :new
        end
    end
    
    def update
        if @product.update(product_params)
            # Process uploaded file and store it permanently
            @product.image.store! if @product.image.present?
            redirect_to @product, notice: 'Product was successfully updated.'
        else
            render :edit
        end
    end
    
    def create_bulk
        
        if params[:csv_file].present?
            csv_data = File.read(params[:csv_file])
            csv = CSV.parse(csv_data, :headers => true)

            @new_products = []
            csv.each do |row|
                product = Product.new(
                    sku: row["sku"],
                    name: row["nombre"],
                    description: row["descripcion"],
                    list_price: row["precio_lista"],
                    price: row["precio_descuento"],
                    active: row["activo"],
                    tags: row["tags"])
                
                @new_products << product
            end
        end
    end

    private
    
    def product_params
        params.require(:product).permit(:sku,:name,:description,:price,:list_price,:active,:tags, {images: []})
    end
    
end
