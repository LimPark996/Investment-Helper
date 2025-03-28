package org.example.investment_guides.dto;

public record APIClientParam(String url, String method, String body, String[] headers) {
}