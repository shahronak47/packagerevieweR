context('Tests', () => {
    beforeEach(() => {
      cy.visit('https://shahronak.shinyapps.io/packagerevieweR/')
})
    it('Can login succesfully in the app', () => {
        cy.get('#username').type(Cypress.env('APP_USERNAME'));
        cy.get('#password').type(Cypress.env('APP_PASSWORD'));
        cy.get('#login_btn').click();
        cy.get('#selected_package-label').should('have.text', 'Select a package to view the reviews.');
    })
})
