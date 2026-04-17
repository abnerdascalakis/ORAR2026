class ADistritosController < ApplicationController
  before_action :set_a_distrito, only: %i[ show edit update destroy ]

  # GET /a_distritos or /a_distritos.json
  def index
    @a_distritos = ADistrito.all
  end

  # GET /a_distritos/1 or /a_distritos/1.json
  def show
  end

  # GET /a_distritos/new
  def new
    @a_distrito = ADistrito.new
  end

  # GET /a_distritos/1/edit
  def edit
  end

  # POST /a_distritos or /a_distritos.json
  def create
    @a_distrito = ADistrito.new(a_distrito_params)

    respond_to do |format|
      if @a_distrito.save
        format.html { redirect_to @a_distrito, notice: "A distrito was successfully created." }
        format.json { render :show, status: :created, location: @a_distrito }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @a_distrito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /a_distritos/1 or /a_distritos/1.json
  def update
    respond_to do |format|
      if @a_distrito.update(a_distrito_params)
        format.html { redirect_to @a_distrito, notice: "A distrito was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @a_distrito }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @a_distrito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /a_distritos/1 or /a_distritos/1.json
  def destroy
    @a_distrito.destroy!

    respond_to do |format|
      format.html { redirect_to a_distritos_path, notice: "A distrito was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_a_distrito
      @a_distrito = ADistrito.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def a_distrito_params
      params.expect(a_distrito: [ :nome ])
    end
end
