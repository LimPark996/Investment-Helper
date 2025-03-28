package org.example.investment_guides.model;

public class FAQ {
    private String question;
    private String answer;
    private String category;

    public FAQ(String question, String answer) {
        this.question = question;
        this.answer = answer;
        this.category = category;
    }

    public String getQuestion() {
        return question;
    }

    public String getAnswer() {
        return answer;
    }

    public String getCategory() { return category; }
}