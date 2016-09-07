Util =
  normalizeData: (data) ->
    return unless $.isArray data
    province = {}
    city = {}
    county = {}

    for p in data
      province[p.code] =
        code: p.code
        name: p.name
        cities: []
      for c in p.cities
        province[p.code].cities.push c.code
        city[c.code] =
          code: c.code
          name: c.name
          counties: []
        for ct in c.counties
          city[c.code].counties.push ct.code
          county[ct.code] =
            code: ct.code
            name: ct.name
    { province: province, city: city, county: county }

module.exports = Util
