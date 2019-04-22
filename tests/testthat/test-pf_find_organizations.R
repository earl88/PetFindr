context("test-pf_find_organizations")

  test_that(" provide the correct limit", {
    pf_accesstoken("9XDk9x1IpkaRt0ebypatBNgF4zV9MeVkSjW1bDtiId8LWd2bPX", 
                   "eqU3FlGSfGsdvgKKSifJlLBB4wsxqzqvQJ9njHjX")
    # expect an error due to incorrect state
    expect_error(pf_find_organizations(token, country = "US",
                                      limit = 100, sort = recent))
    expect_error(pf_find_organizations(token, country = "US",
                                      limit = 1:2, sort = "recent"))
    # expect an error due to page 
    expect_error(pf_find_organizations(token, country = "US",
                                      limit = 101, sort = "recent"))
    # expect an error due to non-numeric limit
    expect_error(pf_find_organizations(token, country = "US",
                                       limit = "hundred", sort = "recent"))
  })

