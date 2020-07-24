package main

import (
	"net/http"

	"github.com/labstack/echo/middleware"
	"github.com/labstack/echo"
)

func main() {
	e := echo.New()
	e.Use(middleware.Logger())
	e.GET("/hello", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, world!")
	})
	e.GET("/healthy", func(c echo.Context) error {
		return c.String(http.StatusOK, "healthy")
	})
	e.Logger.Info(Sum(1, 2))
	e.Logger.Fatal(e.Start(":1323"))
}

// Sum is a,b is sum
func Sum(a, b int) int {
	return a + b
}
