class User < ActiveRecord::Base
    has_one_time_password
end
