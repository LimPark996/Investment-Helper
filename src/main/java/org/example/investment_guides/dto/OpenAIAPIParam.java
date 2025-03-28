package org.example.investment_guides.dto;

import org.example.investment_guides.common.ModelType;

public record OpenAIAPIParam(String prompt, ModelType modelType) {
}