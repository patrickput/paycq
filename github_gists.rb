require "json_matchers/rspec" # https://github.com/thoughtbot/json_matchers
require './setup.rb'
require './testdata.rb'

$SHOW_INFO = false

def show_gists_list(json_list, description = "Overview of gists")
    public_gists_info = json_body.collect{|gist| "       # #{gist[:id]} = #{gist[:description]}"}
    if public_gists_info.size > 0
        puts_info "#{description} (#{json_list.size}):\n#{public_gists_info.join("\n")}"
    else
        puts_info "No gists found"
    end
end

def puts_info(line, prefix = "     ### ")
    puts "#{prefix}#{line}" if $SHOW_INFO
end

describe "Github Gists API Calls" do

    list_of_gist_ids = [] # Since I do not see an id returned when I create a new gist, this list can be used to find out the newly added one
    latest_gist_id = nil

    describe "Public list" do

        before "Get the public list of gists" do
            get "/gists/public"
        end

        it "list - Should return 200" do
            show_gists_list(json_body)
            expect_status(200)
        end

        it "list - Should return JSON with charset UTF-8" do
            expect_header(:content_type, 'application/json; charset=utf-8')
        end

        it "list - Each gist should have the expected schema" do
            json_body.each do |gist|
                expect(gist).to match_response_schema("github_gists_list.schema")
            end
        end

        it "list - At least 30 public gists expected" do
            expect(json_body.size).to be >= 30
        end

    end # Get public list

    describe "Private list" do

        before "Get the private list of gists" do
            get "/users/patrickput/gists"
        end

        it "list - Should return 200" do
            expect_status(200)
        end

        it "list - Should return JSON with charset UTF-8" do
            expect_header(:content_type, 'application/json; charset=utf-8')
        end

        it "list - no gists expected" do
            expect(json_body.size).to eq 0
            show_gists_list(json_body)
        end

        it "Create new gist" do
            post "/gists", Testdata::GIST_RUBY
            get "/users/patrickput/gists"
            list_of_gist_ids = json_body.collect{|gist| gist[:id]}
        end

        it "list - one gist expected" do
            expect(json_body.size).to eq 1
        end

        it "list - The gist should have the expected schema" do
            expect(json_body[0]).to match_response_schema("github_gists_list.schema")
        end

        it "list - Created gist is owned by 'patrickput' and some extra checks for this user" do
            expect(json_body[0][:owner][:login]).to eq("patrickput")
            expect(json_body[0][:owner][:id]).to eq(43065717)
            expect(json_body[0][:owner][:url]).to eq("https://api.github.com/users/patrickput")
            expect(json_body[0][:owner][:html_url]).to eq("https://github.com/patrickput")
        end

        it "list - Only the two ruby related files are expected" do
            files = json_body[0][:files].keys
            expect(files).to match_array([:"hello_world.rb", :"hello_world_ruby.txt"])
        end

        it "Change the gist" do
            get "/users/patrickput/gists"
            expect(json_body.size).to eq 1
            id_to_change = json_body[0][:id]
            puts_info ">> Changing gist with id #{id_to_change}"
            patch "/gists/#{id_to_change}", Testdata::GIST_RUBY_CHANGED
        end

        it "list - Still only one gist expected" do
            expect(json_body.size).to eq 1
        end

        it "list - The gist should have the expected schema" do
            expect(json_body[0]).to match_response_schema("github_gists_list.schema")
        end

        it "list - The new file is present and the old file is not" do
            files = json_body[0][:files].keys
            expect(files).to match_array([:"hello_world2.rb", :"hello_world_ruby.txt"])
        end

        it "Add second gist" do
            post "/gists", Testdata::GIST_PYTHON
            get "/users/patrickput/gists"
            latest_gist_id = (json_body.collect{|gist| gist[:id]} - list_of_gist_ids)[0]
            puts_info "The new gist has id #{latest_gist_id}"
            get "/users/patrickput/gists" # Fill new list
            list_of_gist_ids << latest_gist_id # Now we can add it to the list
        end

        it "list - two gists expected" do
            expect(json_body.size).to eq 2
        end

        it "list - All gists should have the expected schema" do
            json_body.each do |gist|
                expect(gist).to match_response_schema("github_gists_list.schema")
            end
        end

        it "list - The new gist has the two Python related files" do
            call = "/gists/#{latest_gist_id}"
            get call
            files = json_body[:files].keys
            expect(files).to match_array([:"hello_world.py", :"hello_world_python.txt"])
        end

        it "Add third gist" do
            post "/gists", Testdata::GIST_RUBY
            get "/gists"
            latest_gist_id = (json_body.collect{|gist| gist[:id]} - list_of_gist_ids)[0]
            puts_info "The new gist has id #{latest_gist_id}"
            list_of_gist_ids << latest_gist_id # Now we can add it to the list
        end

        it "list - three gists expected" do
            expect(json_body.size).to eq 3
        end

        it "remove latest gist (Ruby)" do
            puts_info ">> Deleting gist with id #{latest_gist_id}"
            delete "/gists/#{latest_gist_id}"
        end

        it "Latest gist (Ruby) is no longer present" do
            get "/gists/#{latest_gist_id}"
            expect_json(message: "Not Found")
            expect_json(documentation_url: "https://developer.github.com/v3/gists/#get-a-single-gist")
        end

        it "list - two gists expected" do
            expect(json_body.size).to eq 2
        end

        it "Adding invalid gist does not work" do
            post "/gists", Testdata::GIST_INVALID
            expect_json(message: "Invalid request.\n\n\"files\" wasn't supplied.")
            expect_json(documentation_url: "https://developer.github.com/v3/gists/#create-a-gist")
            get "/gists"
            expect(json_body.size).to eq 2 # Still 2 gists
        end

        it "remove all gists" do
            show_gists_list(json_body)
            get "/users/patrickput/gists"
            list_to_remove = json_body.collect{|x| x[:id]}
            puts_info ">> Deleting all #{list_to_remove.size} gists..."
            list_to_remove.each do |gist_id|
                delete "/gists/#{gist_id}"
            end
        end

        it "list - no gists expected" do
            get "/users/patrickput/gists"
            expect(json_body.size).to eq 0
        end

    end # Private list

end