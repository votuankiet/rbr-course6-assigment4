class InquiryPolicy < ApplicationPolicy
	def index?
    true
  end
  def show?
    organizer?
  end
  def create?
    @user
  end
  def update?
    organizer?
  end
  def destroy?
    organizer_or_admin?
  end

  class Scope < Scope
    def user_roles
      joins_clause=["left join Roles r on r.mname='Inquiry'",#add_role method will set mname = object.model_name.name, http://api.rubyonrails.org/classes/ActiveModel/Naming.html#method-i-model_name
                    "r.mid=Inquiries.id",
                    "r.user_id #{user_criteria}"].join(" and ")
      scope.select("Images.*, r.role_name")
           .joins(joins_clause)
    end

    def resolve
      user_roles
    end
  end
end
