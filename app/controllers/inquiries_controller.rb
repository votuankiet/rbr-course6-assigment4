class InquiriesController < ApplicationController
  before_action :set_inquiry, only: [:show, :update, :destroy]
  wrap_parameters :inquiry, include: ["title", "description"]
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]
  # GET /inquiries
  # GET /inquiries.json
  def index
    authorize Inquiry #is the user allowed to list image
    @inquiries = policy_scope(Inquiry.where(creator_id: current_user.id)) # left join inquiries table with roles table to get all image attribute and coressponding role name, return a scope
    @inquiries = InquiryPolicy.merge(@inquiries) # append user's roles array to the return result, convert the sope to array of models
  end

  # GET /inquiries/1
  # GET /inquiries/1.json
  def show
    authorize @inquiry
    inquiries = policy_scope(Image.where(:id=>@image.id))
    @inquiry = ImagePolicy.merge(inquiries).first
  end

  # POST /inquiries
  # POST /inquiries.json
  def create
    authorize Inquiry
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.creator_id=current_user.id

    User.transaction do
      if @inquiry.save
        role=current_user.add_role(Role::ORGANIZER, @inquiry)
        @inquiry.user_roles << role.role_name #not saved to database, just add current role to user_roles array of the entity
        role.save!
        render :show, status: :created, location: @inquiry
      else
        render json: {errors:@inquiry.errors.messages}, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /inquiries/1
  # PATCH/PUT /inquiries/1.json
  def update
    @inquiry = Inquiry.find(params[:id])

    if @inquiry.update(inquiry_params)
      head :no_content
    else
      render json: {errors:@inquiry.errors.messages}, status: :unprocessable_entity
    end
  end

  # DELETE /inquiries/1
  # DELETE /inquiries/1.json
  def destroy
    
    @inquiry.destroy

    head :no_content
  end

  private

    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end

    def inquiry_params
      params.require(:inquiry).permit(:title, :description)
    end
end
