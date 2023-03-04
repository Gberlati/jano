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
    
    private
    
    def product_params
        params.require(:product).permit(:name, {images: []})
    end
    
end
