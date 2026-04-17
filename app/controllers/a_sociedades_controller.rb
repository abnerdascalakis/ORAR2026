class ASociedadesController < ApplicationController
  before_action :set_a_sociedade, only: %i[ show edit update destroy ]

  # GET /a_sociedades or /a_sociedades.json
  def index
    @a_sociedades = ASociedade.all
  end

  # GET /a_sociedades/1 or /a_sociedades/1.json
  def show
  end

  # GET /a_sociedades/new
  def new
    @a_sociedade = ASociedade.new
  end

  # GET /a_sociedades/1/edit
  def edit
  end

  # POST /a_sociedades or /a_sociedades.json
  def create
    @a_sociedade = ASociedade.new(a_sociedade_params)

    respond_to do |format|
      if @a_sociedade.save
        format.html { redirect_to @a_sociedade, notice: "A sociedade was successfully created." }
        format.json { render :show, status: :created, location: @a_sociedade }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @a_sociedade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /a_sociedades/1 or /a_sociedades/1.json
  def update
    respond_to do |format|
      if @a_sociedade.update(a_sociedade_params)
        format.html { redirect_to @a_sociedade, notice: "A sociedade was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @a_sociedade }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @a_sociedade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /a_sociedades/1 or /a_sociedades/1.json
  def destroy
    @a_sociedade.destroy!

    respond_to do |format|
      format.html { redirect_to a_sociedades_path, notice: "A sociedade was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_a_sociedade
      @a_sociedade = ASociedade.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def a_sociedade_params
      params.expect(a_sociedade: [ :nome, :a_distrito_id ])
    end
end
