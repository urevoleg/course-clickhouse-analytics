CREATE TABLE kinopoisk_parsing_result (
    id UInt32,
    search_item String,
    search_url String,
    film_id UInt32orNull,
    film_url String,
    film_name String,
    production_year String,
    country String,
    genre String,
    director String,
    screenwriter String,
    operator String,
    compositor String,
    painter String,
    mount String,
    budget String,
    box_office_usa String,
    box_office_world String,
    box_office_russia String,
    rating_kp_top Float,
    marks_amount_kinopoisk String,
    rating_kp_pos String,
    rating_kp_neu String,
    rating_kp_neg String,
    rating_imbd String,
    marks_amount_imbd String,
    release_world String,
    release_russia String,
    digital_release String,
    checked_at String,
    error String,
    poster_link String,
    film_descr String
) ENGINE = Log;