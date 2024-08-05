context('Tests', () => {
    beforeEach(() => {
      cy.visit('https://shahronak.shinyapps.io/packagerevieweR/')
})
    it('Can login succesfully in the app', () => {
        cy.get('#username').type('shahronak47');
        cy.get('#password').type('test');
        cy.get('#login_btn').click();
        cy.get('#selected_package-label').should('have.text', 'Select a package to view the reviews.');
    })
})