class RoomsController < BaseController
	
	before_action :find_room, except: [:index, :new, :create]

	def index
		@rooms = current_account.rooms
	end

	def new
		@room = Room.build({account_id: current_account.id})
	end

	def create
		@room 						= Room.build(room_params)
		@room.account_id 	= current_account.id
		if @room.save
			redirect_to rooms_path, notice: "Successfully created room."	
		else
			render action: :new
		end
	end

	def show
	end

	def edit
	end

	def update
		if @room.update_attributes(room_params)
			redirect_to rooms_path, notice: 'Successfully updated room.'
		else
			render action: :edit
		end
	end

	def destroy
		@room.destroy if @room.present?
		render json: @room
	end

	private

	def room_params
		params.require(:room).permit(:name, :first_appointment_time, :last_appointment_time, :minute_units, :duration_units)
	end

	def find_room
		@room = current_account.rooms.find(params[:id])
	end

end
