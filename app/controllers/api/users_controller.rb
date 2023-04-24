require 'bcrypt'
require 'jwt'
require 'fileutils'
require('base64')
require "rqrcode"

class Api::UsersController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def LOGIN        
        # start = Time.now.to_i
        # exp = Time.now.to_i + 4 * 3600
        # print("START TIME :",start)
        # print("EXPIRY TIME : ", exp)


        # SEARCH USERNAME
        @user = User.find_by_username(params[:username])
        if @user
            begin
                session[:user_id] = @user.id
                # ENCRYPT PASSWORD
                @ispassword = BCrypt::Password.new(@user.password)

                # COMPARE INPUT PASSWORD
                if @ispassword == params[:password]
                    exp = Time.now.to_i + 4 * 3600
                    payload = { data: @user.id, exp: exp }
                    token = JWT.encode payload, @user.secretkey, 'HS256'
                    return render :json => {'statuscode' => 200,
                        'message' => 'Login Successfull, please wait.',
                        'userid': @user.id,
                        'username': @user.username,
                        'emailadd': @user.emailadd,
                        'isactivated': @user.isactivated,
                        'isblocked': @user.isblocked,
                        'picture': @user.picture,
                        'qrcodeurl': @user.qrcodeurl,
                        'token': token}
                end
                return render :json => {'statuscode' => 404, 'message' => 'Invalid Password.'}
            rescue => e
            end
        else
            render :json => {'statuscode' => 404, 'message' => 'Access Denied.'}
        end
    end    

    def REGISTER
        secretkey = BCrypt::Password.create(params[:emailadd])
        pic = "http://127.0.0.1:3000/users/user.jpg"
        # ENCRYPT PASSWORD
        hash_password = BCrypt::Password.create(params[:password])
        @user = User.new(lastname: params[:lastname], firstname: params[:firstname], emailadd: params[:emailadd], mobileno: params[:mobileno], username: params[:username], password: hash_password, secretkey: secretkey, picture: pic)

        # CHECK EMAIL ADDRESS
        @emailuser = User.find_by_emailadd(params[:emailadd])
        if @emailuser
            return render :json => {'statuscode' => 400, 'message' => 'Email Address has already been taken.'}
        end

        # CHECK USERNAME
        @username = User.find_by_username(params[:username])
        if @username
            return render :json => {'statuscode' => 400, 'message' => 'Username has already been taken.'}
        end

        # SAVE INPUT
        if @user.save!
            render :json => {'statuscode' => 200, 'message' => 'You have registered successfully.'}
        else
            render error: { error: 'Unable to create User.'}, status: 400
        end              
    end

    def GETUSERBYID
        # print("caption", "data")
        # begin
            # @usr = User.find(params[:id])
            # hdr = request.headers["Authorization"]
            # hdr = hdr.split(" ").last || hdr              
            # decoded_token = JWT.decode hdr, @usr.secretkey, true, { algorithm: 'HS256' }
            @user = User.find(params[:id])
            render :json => {'statuscode': 200,'userid': @user.id, 'lastname': @user.lastname, 'firstname': @user.firstname,
            'emailadd': @user.emailadd, 'mobileno': @user.mobileno, 'role': @user.role, 'picture': @user.picture,
            'isactivated': @user.isactivated, 'isblocked': @user.isblocked, 'qrcodeurl': @user.qrcodeurl}
        # rescue JWT::ExpiredSignature
        #     render :json => {'statuscode' => 404, 'message' => 'TOKEN Expired, please logout then login again.'}
        # rescue JWT::DecodeError
        #     render :json => {'statuscode' => 404, 'message' => 'UnAthorized Access.'}
        # end
    end

    def GETALLUSERS
        begin
            @usr = User.find(session[:user_id])
            hdr = request.headers["Authorization"]
            hdr = hdr.split(" ").last || hdr
            decoded_token = JWT.decode hdr, @usr.secretkey, true, { algorithm: 'HS256' }
            @users = User.all
            render json: @users
        rescue => e
            render :json => {'statuscode' => 404, 'message' => 'UnAthorized Access.'}
        end
    end

    def UPDATEUSERPROFILE
        @lname = params[:lastname]
        @fname = params[:firstname]
        @mobile = params[:mobile]
        @password = params[:password]
        print("LASTNAME : ", @lname)
        print("FIRSTNAME : ", @fname)
        print("MOBILE NO. : ", @mobile)
        if @password.length === 0
            print("PASSWORD IS EMPTY ")
        else
            print("PASSWORD IS NOT EMPTY ")
        end
        render :json => {'statuscode' => 200, 'message' => 'Ok.'}
    end

    def UPDATEUSERPICTURE
        @id = params[:id]
        @ext = params[:ext]
        @urlpic = 'http://127.0.0.1:3000/users/00' + @id+ @ext
        # SAVE TO DATABASE
        @usr = User.find(@id)

        # REMOVE OLD PICTURE
        oldext = File.extname(URI.parse(@usr.picture).path)
        FileUtils.rm('./public/users/00' + @id + oldext)

        @usr.picture = @urlpic
        # @usr.picture = params[:user]
        @usr.save!


        # SAVE TO PUBLIC/USERS FOLDER
        path = './public/users/00' + @id
        base64_to_file(params[:user],path, @ext)

        render :json => {'statuscode' => 200, 'message' => 'picture Ok.'}
    end

    def ACTIVATEMFA
        @id = params[:id]
        @isok = params[:isactivated]
        if @isok === 'Y'
            @user = User.find(@id)
            @fullname = @user.firstname + ' ' + @user.lastname
            qrcode = RQRCode::QRCode.new(@user.provisioning_uri(@fullname, issuer: 'QATAR BANK'))
            # svg = qrcode.as_svg(
            #     color: "000",
            #     shape_rendering: "crispEdges",
            #     module_size: 11,
            #     standalone: true,
            #     use_path: true
            #   )

            png = qrcode.as_png(
                bit_depth: 1,
                border_modules: 4,
                color_mode: ChunkyPNG::COLOR_GRAYSCALE,
                color: "black",
                file: nil,
                fill: "white",
                module_px_size: 6,
                resize_exactly_to: false,
                resize_gte_to: false,
                size: 200
              )
              path = './public/qrcodes/00' + @id + '.png'
              xfile = IO.binwrite(path, png.to_s)
              urlpng = 'http://127.0.0.1:3000/qrcodes/00'+ @id + '.png'
            @user.qrcodeurl = urlpng
            @user.save!
            render :json => {'statuscode' => 200, 'message' => "2-Factor Authentication has been enabled."}
        else
            FileUtils.rm('./public/qrcodes/00' + @id + '.png') # remove qrcode file
            @user = User.find(@id)
            @user.qrcodeurl = nil
            @user.save!
            render :json => {'statuscode' => 200, 'message' => "2-Factor Authentication has been disabled."}
        end
    end

    def VALIDATETOKEN
        begin
            @id = params[:id]
            @otp = params[:otpcode]
            @user = User.find(@id)
            if @user.authenticate_otp(@otp)
                return render :json => {'statuscode' => 200,
                    'message' => 'Validating OTP Code, please wait.',
                    'username': @user.username}

            else
                render :json => {'statuscode' => 404, 'message' => "OTP Code not valid, please try again."}
            end
        rescue => e
            render :json => {'statuscode' => 404, 'message' => "OTP Code not valid, please try again."}
        end
    end

    def base64_to_file(base64_data, filename = 'image', ext)
        return base64_data unless base64_data.present? && base64_data.is_a?(String)
      
        regex = /data:image\/([a-z]{3,4});base64,/
        type_fetch_regex = /\/(.*?);/
        start_text = regex.match(base64_data)
        if start_text #&& type
          file = File.new("#{filename}#{ext}", 'wb')
          file.write(Base64.decode64(base64_data[start_text.to_s.length..-1]))
        else
          nil
        end
      end

    private

    def user_params
        params.require(:user).permit(:lastname, :firstname,  :emailadd, :mobileno, :username, :password, :user, :otpcode)
    end

end







