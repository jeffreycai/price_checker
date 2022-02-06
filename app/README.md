# Simple Coinbase Spot Price Checker

A wrapper web app that calls coinbase API to fetch spot price for a given currency.

Example endpoints:

| URL | Comments |
|-----|----------|
| http://localhost:8080 | Homepage, a list of all Coinbased supported currencies |
| http://localhost:8000 | Metrics |
| http://localhost:8080/health | Health check point |
| http://localhost:8080/USD | USD spot price |
| http://localhost:8080/NILL | Example invalid currency call |