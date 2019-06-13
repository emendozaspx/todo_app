module Main exposing (Model, Msg(..), init, main, subscriptions, update, view, viewLink)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, bool, field, int, map4, string)
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success Todo


type alias Todo =
    { id : Int
    , title : String
    , body : String
    , isComplete : Bool
    }


todosDecoder : Decoder Todo
todosDecoder =
    map4 Todo
        (field "id" int)
        (field "title" string)
        (field "body" string)
        (field "isComplete" bool)


getTodos : Cmd Msg
getTodos =
    Http.get
        { url = "http://localhost:8000/api/todos"
        , expect = Http.expectJson GotTodos todosDecoder
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getTodos )



-- UPDATE


type Msg
    = FailedGet
    | GotTodos (Result Http.Error Todo)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        [ text "Euan's Todo App"
        , b [] [ text (Url.toString model.url) ]
        , ul []
            [ viewLink "/home"
            , viewLink "/profile"
            , viewLink "/reviews/the-century-of-the-self"
            , viewLink "/reviews/public-opinion"
            , viewLink "/reviews/shah-of-shahs"
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
