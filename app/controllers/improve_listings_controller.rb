class ImproveListingsController < ApplicationController
  respond_to :json

  def create
    # listing = Listing.find(params[:listing_id])
    # listing.improve_listings.create(params[:improve_listing])

    # FIXME boolean value in db for term_num_nis ?
    # listing.improve_listings.create({
    ImproveListing.create({
      listing_id: params[:listing_id],
      comment: params[:improve_listing][:comment],
      term_num_nis: (params[:improve_listing][:term_num_nis] == "true" ? 1 : 0)
    })
    render nothing: true
  end
end
