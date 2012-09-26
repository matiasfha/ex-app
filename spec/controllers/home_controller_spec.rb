require 'spec_helper'

describe "Home page" do
	context "Sin autenticar" do 
		it "Mostrar los botones de ingreso" do 
			visit root_path
			page.should have_content "Ingresar con"
		end
	end
end
