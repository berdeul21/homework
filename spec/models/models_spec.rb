require 'rails_helper'

RSpec.describe '2번 문제 모델 테스트', type: :model do
	context "사용자를 생성한다" do
	  it "이메일, 비밀번호, 닉네임, 성별, 생년월을 입력하여 생성한다" do
	  	expect(User.count).to eq 0 # 이후로부터 생략

	    User.create(
	    		email: Faker::Internet.email,
	    		password: Faker::Internet.password,
	    		nickname: 'ohou',
	    		gender: Faker::Gender.binary_type,
	    		birth: '201906'
	    	)
	    expect(User.count).to eq 1
	  end

	  it "닉네임으로 구분한다" do
	  	2.times do
		    User.create(
		    		email: Faker::Internet.email,
		    		password: Faker::Internet.password,
		    		nickname: 'ohou',
		    		gender: Faker::Gender.binary_type,
		    		birth: '201906'
		    	)
		  end
	    expect(User.count).to eq 1
	  end

	  it "facebook이나 naver를 이용해 로그인한다" do
	  	info_from_omniauth_facebook = {
	  		provider: 'facebook',
			  uid: '1234567',
			  extra: {
			    raw_info: {
			      username: 'jbloggs',
			      gender: 'male',
			      email: 'joe@bloggs.com',
			      # ...
			    }
			  }
	  	}
	  	
	    User.create(
	    		email: info_from_omniauth_facebook[:extra][:raw_info][:email],
	    		password: Faker::Internet.password,
	    		nickname: info_from_omniauth_facebook[:extra][:raw_info][:username],
	    		gender: info_from_omniauth_facebook[:extra][:raw_info][:gender],
	    	)
	    expect(User.count).to eq 1
	  end
	end 

	2.times do |i|
		let("user#{i}".to_sym) { User.create(
		    		email: Faker::Internet.email,
		    		password: Faker::Internet.password,
		    		nickname: Faker::Movies::HarryPotter.character,
		    		gender: Faker::Gender.binary_type,
		    		birth: '201906'
		    	) }
	end

	context "사용자는 사진을 생성한다" do
		it "카테고리, 설명을 입력하여 사진을 생성할 수 있다" do
			expect(Photo.where(user_id: user0.id).count).to eq 0

	    Photo.create(
	    		user_id: user0.id,
	    		image_url: Faker::Avatar.image("my-own-slug", "50x50", "jpg"),
	    		category: Faker::House.room,
	    		description: Faker::Lorem.paragraph
	    	)
	    expect(Photo.where(user_id: user0.id).count).to eq 1
	  end
	end

	3.times.each do |i|
		let("photo#{i}".to_sym) { 
					Photo.create(
	    		user_id: user0.id,
	    		image_url: Faker::Avatar.image("my-own-slug", "50x50", "jpg"),
	    		category: Faker::House.room,
	    		description: Faker::Lorem.paragraph
	    	) }
	end
	let(:album) { Album.create(
					user_id: user0.id,
					summary: Faker::Lorem.paragraph
				) }

	context "사용자는 사진 묶음을 생성한다" do
		it "요약글을 입력하여 사진묶음을 생성한다" do
			expect(Album.where(user_id: user0.id).count).to eq 0

			Album.create(
					user_id: user0.id,
					summary: Faker::Lorem.paragraph
				)
			expect(Album.where(user_id: user0.id).count).to eq 1
		end

		it "사진을 순서를 입력하여 사진묶음에 넣는다" do
			Collect.create(
					album_id: album.id,
					photo_id: photo0.id,
					seq: 2
				)
			Collect.create(
					album_id: album.id,
					photo_id: photo1.id,
					seq: 1
				)
			expect(album.collects.order('seq ASC').pluck(:photo_id)).to eq [photo1.id, photo0.id]
		end

		it "사진묶음의 대표사진을 지정한다" do
			Collect.create(
					album_id: album.id,
					photo_id: photo2.id,
					seq: 3,
					cover: true
				)
			expect(album.collects.find_by(cover: true).photo.id).to eq photo2.id
		end
	end

	let(:comment) { album.comments.create(
					user_id: user0.id,
					body: Faker::Lorem.sentence
				) }

	context "사용자는 댓글을 생성한다" do
		it "사진에 댓글을 생성한다" do
			expect(photo1.comments.count).to eq 0

			photo1.comments.create(
					user_id: user0.id,
					body: Faker::Lorem.sentence
				)
			expect(photo1.comments.count).to eq 1
		end

		it "사진묶음에 댓글을 생성한다" do
			expect(album.comments.count).to eq 0

			album.comments.create(
					user_id: user0.id,
					body: Faker::Lorem.sentence
				)
			expect(album.comments.count).to eq 1
		end

		it "댓글에 대댓글을 생성한다" do
			expect(comment.replies.count).to eq 0

			album.comments.create(
					user_id: user0.id,
					parent_id: comment.id
				)
			expect(comment.replies.count).to eq 1
		end
	end

	context "사용자는 좋아요를 한다" do
		it "사진에 좋아요를 한다" do
			expect(photo2.likes.count).to eq 0

			photo2.comments.create(
					user_id: user0.id
				)
			expect(photo2.comments.count).to eq 1
		end

		it "사진묶음에 좋아요를 한다" do
			expect(album.likes.count).to eq 0

			album.comments.create(
					user_id: user0.id
				)
			expect(album.comments.count).to eq 1
		end
	end

	context "사용자는 친구맺기를 한다" do
		it "친구맺기를 한다" do
			expect(user0.followings.count).to eq 0
			expect(user1.followers.count).to eq 0

			user0.following_relationships.create(
					following_id: user1.id
				)

			expect(user0.followings.count).to eq 1
			expect(user1.followers.count).to eq 1
		end
	end
end
