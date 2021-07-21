view: inventory_items {
  sql_table_name: "PUBLIC"."INVENTORY_ITEMS"
    ;;
  drill_fields: [id]

  set: inventory_detail {
    fields: [id, product_name, products.id, products.name, order_items.count]
  }



  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension: high_cost {
    description: "Yes means unusally high inventoy cost, > 400"
    type:  yesno
    sql:  ${cost}>400 ;;
  }

  dimension: cost_minus_tax {
    type: number
    sql: ${cost}*0.75;;
    value_format_name: eur_0
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}."PRODUCT_BRAND" ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}."PRODUCT_CATEGORY" ;;
  }

  dimension: product_brand_and_category {
    type:  string
    sql: ${product_brand} || ' ' || ${product_category} ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}."PRODUCT_DEPARTMENT" ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}."PRODUCT_DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}."PRODUCT_RETAIL_PRICE" ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}."PRODUCT_SKU" ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SOLD_AT" ;;
  }

  dimension_group: date_diff_created_sold {
    type:  duration
    intervals: [day]
    sql_start: ${created_raw} ;;
    sql_end: ${sold_raw} ;;
  }

  dimension: date_diff_tier {
    type: tier
    label: "Date difference between created date and date sold"
    tiers: [0,10,20,30]
    style: integer
    sql: ${days_date_diff_created_sold} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }


  measure: count_distinct_prod{
    type: count_distinct
    drill_fields: [inventory_detail*]
    sql:  ${product_name} ;;
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: eur_0
  }

  measure: average_cost {
    type: average
    sql: ${cost} ;;
    value_format_name: eur_0
  }
}
