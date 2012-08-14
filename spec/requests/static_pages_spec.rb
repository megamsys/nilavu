require 'spec_helper'

describe "Pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1',    text: 'Megam - opensource') }
    it { should have_selector('title', text: full_title('')) }
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "About page" do
    before { visit page_path("about") }

    it { should have_selector('h1',    text: 'About') }
    it { should have_selector('title', text: full_title('About')) }
  end

  describe "Doc page" do
    before { visit page_path("doc") }

    it { should have_selector('h1',    text: 'Doc') }
    it { should have_selector('title', text: full_title('Doc')) }
  end

  describe "Contribute page" do
    before { visit page_path("contribute") }

    it { should have_selector('h1',    text: 'Contribute') }
    it { should have_selector('title', text: full_title('Contribute')) }
  end

  describe "Contact us page" do
    before { visit page_path("contact_us") }

    it { should have_selector('h1',    text: 'Contact us') }
    it { should have_selector('title', text: full_title('Contact us')) }
  end

describe "Get Started page" do
    before { visit page_path("get_started") }

    it { should have_selector('h1',    text: 'Get Started') }
    it { should have_selector('title', text: full_title('Get Started')) }
  end


 it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')

    click_link "Documentation"
    page.should have_selector 'title', text: full_title('Doc')

    click_link "Getting started"
    page.should have_selector 'title', text: full_title('Get Started')

    click_link "Contact us"
    page.should have_selector 'title', text: full_title('Contact us')

    click_link "Contribute"
    page.should have_selector 'title', text: full_title('Contribute')

    click_link "Read Our Blog"
    
 end

end

  

