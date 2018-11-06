module BannerImage exposing (BannerImage, current_image, first_img, images, next_banner_image)

import RollingList


type alias BannerImage =
    { id : Int
    , duration : Int
    }


first_img =
    BannerImage 1 3000


current_image rolling =
    case RollingList.current rolling of
        Nothing ->
            first_img

        Just img ->
            img


images =
    RollingList.fromList
        [ first_img
        , BannerImage 2 8000
        , BannerImage 3 5000
        , BannerImage 4 4000
        , BannerImage 5 13000
        , BannerImage 6 9000
        , BannerImage 7 5000
        ]


next_banner_image =
    RollingList.roll images
