# JSON API

Notice: To use this api, cookies must be enabled.

* [Search](#search)
    * [Request](#request)
    * [Response](#response)
* [View Phone Number](#view-phone-number)
    * [Request Example](#request-example)
* [Suggestions](#suggestions)
    * [Examples](#examples)

# Search

* Description

For every search request, we usually display 10 `listings` and 6 `ads`. 
These resources are almost identical so they use the same parameters.

* Resources

<table>
    <tr>
      <th>Resource</th>
      <th>HTTP verb</th>
      <th>Description</th>
    </tr>
    <tr>
        <td><code>api/listings</code></td>
        <td>GET</td>
        <td>Returns <code>listings</code> that match a specified query.</td>
    </tr>
    <tr>
        <td><code>api/ads</code></td>
        <td>GET</td>
        <td>Returns <code>ads</code> that match a specified query.</td>
    </tr>    
</table>

* Parameters

<table>
    <tr>
        <td><code>what</code></td>
        <td>Name of bussines or category</td>
    </tr>
    <tr>
        <td><code>where</code></td>
        <td>Location. Usually name of state or city</td>
    </tr>
    <tr>
        <td><code>limit</code></td>
        <td>Limit</td>
    </tr>
</table>

## Request

Search-request example for `Attorneys` in `Seattle, WA`:

* Listings

         http://wapi.herokuapp.com/api/listings?what=Attorneys&where=Seattle%2C+Wa&limit=10

* Ads

         http://wapi.herokuapp.com/api/ads?what=Attorneys&where=Seattle%2C+Wa&limit=6

## Response
* Response example for `GET` `http://wapi.herokuapp.com/api/listings?what=Attorneys&where=Seattle%2C+Wa&limit=1`:

    ```JSON
    
    [
        {
            "wed_start":-10000,
            "sat_start":-10000,
            "num_type":"3",
            "state":"WA",
            "address1":"11320 Roosevelt Way NE",
            "tue_end":10000,
            "city":"Seattle",
            "id":"15572438",
            "slogan":"Offices of Lawyers",
            "latlon":"47.71610,122.3004",
            "term_num":"+18182931498 64",
            "wed_end":10000,
            "sun_end":10000,
            "fri_start":-10000,
            "zip":"98125-6228",
            "service_area":"City",
            "sun_start":-10000,
            "mon_start":-10000,
            "url":"Lawgate.net",
            "thu_start":-10000,
            "fri_end":10000,
            "mon_end":10000,
            "company":"Del Fierro, Catherine",
            "sat_end":10000,
            "citystate":"Seattle, WA",
            "thu_end":10000,
            "tue_start":-10000,
            "categories":[
                "Attorneys"
            ],
            "score":1.7487535,
            "solr_term_num":"206-365-5500",
            "listing_display_histories_id":8113
        }
    ]
    
# View Phone Number

* Description

Notice: This description assumes that we already got JSON data from previous request (`api/listings` or `api/ads`).

When `"View Phone Number"-link` of particular `listing` or `ad` is clicked, we doing 2 steps:

   * Display phone-number to user.
   
      JSON data of corresponding `listing` or `ad` has a key `term_num`. The value of this key is the phone-number that we need to display.
   
   * Make ajax reques to server.
   
      This step depends on `num_type` of our `listing` or `ad`.
   
      * if `num_type` is 1 or 2, we do nothing.
      * if `num_type` is 3 or more, we need to make `POST` request to server by using this resource: `/api/listings/:id/update_clicked_phone_number`. (to populate parameters, use all corresponding fields from JSON response).

***

* Resources

<table>
    <tr>
      <th>Resource</th>
      <th>HTTP verb</th>
      <th>Description</th>
    </tr>
    <tr>
        <td><code>api/listings/:id/update_clicked_phone_number</code></td>
        <td>POST</td>
        <td>Update phone number</td>
    </tr>    
</table>

* Parameters

<table>
    <tr>
        <td><code>id</code></td>
        <td>required</td>
    </tr>
    <tr>
        <td><code>display_num</code></td>
        <td>required</td>
    </tr>
    <tr>
        <td><code>solr_term_num</code></td>
        <td>required</td>
    </tr>
    <tr>
        <td><code>solr_listing_id</code></td>
        <td>required</td>
    </tr>
    <tr>
        <td><code>listing_display_histories_id</code></td>
        <td>required</td>
    </tr>    
</table>

## Request example

* For example, we got following json data from `api/listings` resource (it's short version).

   ```JSON

   [
      {
         "num_type":"3",
         "id":"15572438",
         "term_num":"+18182931498 64",
         "solr_term_num":"206-365-5500",
         "listing_display_histories_id":8113
      },
      {
         "num_type":"3",
         "id":"123",
         "term_num":"+123 45",
         "solr_term_num":"123-123-1234",
         "listing_display_histories_id":1234
      }
   ]

* That means, if user clicks on the "View-Phone-Number"-link with `id` equals to `15572438`, request should looks like:

   ```JavaScript

   $.ajax({
      type: 'POST',
      url: "http://wapi.herokuapp.com/api/listings/15572438/update_clicked_phone_number",
      data: {
         display_num:                  "+18182931498 64",
         solr_term_num:                "206-365-5500",
         solr_listing_id:              "15572438",
         listing_display_histories_id: "8113"
      }
   });

# Suggestions

### City/State

* Resources

<table>
    <tr>
      <th>Resource</th>
      <th>HTTP verb</th>
      <th>Description</th>
    </tr>
    <tr>
        <td><code>api/suggestions/cities</code></td>
        <td>POST</td>
        <td>Returns <code>suggestions</code> that match a specified query.</td>
    </tr>
</table>

* Parameters


<table>
    <tr>
        <td><code>where</code></td>
        <td>City or State</td>
    </tr>
    <tr>
        <td><code>maxRows</code></td>
        <td>Limit of rows</td>
    </tr>
</table>

### Companies/Categories

* Resources

<table>
    <tr>
      <th>Resource</th>
      <th>HTTP verb</th>
      <th>Description</th>
    </tr>
    <tr>
        <td><code>api/suggestions</code></td>
        <td>POST</td>
        <td>Returns <code>suggestions</code> that match a specified query.</td>
    </tr>
</table>

* Parameters

<table>
    <tr>
        <td><code>where</code></td>
        <td>City or State</td>
    </tr>
    <tr>
        <td><code>what</code></td>
        <td>Companies/Categories</td>
    </tr>
    <tr>
        <td><code>maxRows</code></td>
        <td>Limit of rows</td>
    </tr>
</table>

## Examples

### City/State

#### Request

* Example for `Seat`

      ```
      http://wapi.herokuapp.com/api/suggestions/cities?maxRows=30&where=Seat
    
#### Response
*  Array of suggestions

   ```JSON
   
   [
      "Seattle, WA",
      "Seatac, WA",
      "Seaton, IL",
      "Seatonville, IL"
   ]

### Companies/Categories

#### Request

* Example for `Attor`* in `Steattle, Wa`

      ```
      http://wapi.herokuapp.com/api/suggestions?maxRows=30&what=Attor&where=Seattle%2C+Wa
      
#### Response
* Array of suggestions

     ```JSON
     
      [
         {
            "cat_category":"Specialized attorneys"
         },
         {
            "cat_category":"Attorneys"
         },
         {
            "cat_category":"Environmental Attorneys"
         },
         {
            "cat_category":"Attorney-Bar Associations"
         },
         {
            "company":"Attorney Generals Office",
            "categories":[
               "Legal counsel"
            ]
         },
         {
            "company":"Attorneys Information Bureau",
            "categories":[
               "Information & Referral Svcs"
            ]
         },
         {
            "company":"Attorneys Information",
            "categories":[
               "Information & Referral Svcs"
            ]
         },
         {
            "company":"Attorney At Law Brian Boddy",
            "categories":[
               "Attorneys"
            ]
         },
         {
            "company":"Attorney Bankruptcy Svc",
            "categories":[
               "Attorneys"
            ]
         }
      ]
