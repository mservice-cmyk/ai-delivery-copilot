/**
 * @description Service class for managing AI prompt templates
 * Provides pre-built prompts for different delivery acceleration scenarios
 * @author Salesforce Technical Architect
 * @date 2026-06-18
 */
public with sharing class PromptTemplateService {

    /**
     * @description Get the prompt template for solution design review
     * @param userRequest The user's specific request or context
     * @return PromptTemplate Complete prompt template ready for AI
     */
    public static PromptTemplate getSolutionDesignPrompt(String userRequest) {
        String systemContext = 'You are an expert Salesforce Technical Architect with 15+ years of experience. ' +
                             'Your role is to review solution designs and provide actionable recommendations ' +
                             'focused on scalability, security, best practices, and governor limits. ' +
                             'Provide specific, concrete recommendations with clear rationale.';

        String userPrompt = 'Review the following Salesforce solution design and provide a comprehensive analysis:\n\n';

        if (String.isNotBlank(userRequest)) {
            userPrompt += userRequest + '\n\n';
        } else {
            userPrompt += '[No specific design provided - provide general solution design review guidelines]\n\n';
        }

        userPrompt += 'Please analyze the design and provide:\n' +
                     '1. Executive Summary (2-3 sentences)\n' +
                     '2. Architecture Recommendations (5-7 specific items)\n' +
                     '3. Risk Assessment (4-5 risks with impact and probability)\n' +
                     '4. Action Items (5-7 prioritized tasks with owners and timeline)\n' +
                     '5. Next Steps (4-5 immediate actions)\n\n' +
                     'Focus on:\n' +
                     '- Salesforce governor limits and bulkification\n' +
                     '- Security and sharing model\n' +
                     '- Integration patterns and error handling\n' +
                     '- Performance and scalability\n' +
                     '- Best practices and maintainability\n\n' +
                     'Format your response as structured JSON with these fields:\n' +
                     '- executiveSummary: string\n' +
                     '- recommendations: array of strings\n' +
                     '- risks: array of {description, impact, probability}\n' +
                     '- actionItems: array of {task, priority, owner, duration}\n' +
                     '- nextSteps: array of strings\n' +
                     '- confidenceScore: integer (0-100)';

        return new PromptTemplate(systemContext, userPrompt, 4000);
    }

    /**
     * @description Get the prompt template for user story generation
     * @param userRequest The business requirement or context
     * @return PromptTemplate Complete prompt template ready for AI
     */
    public static PromptTemplate getUserStoryPrompt(String userRequest) {
        String systemContext = 'You are an experienced Business Analyst specializing in Salesforce projects. ' +
                             'You excel at writing clear, actionable user stories with acceptance criteria.';

        String userPrompt = 'Generate comprehensive user stories for the following requirement:\n\n' +
                          (String.isNotBlank(userRequest) ? userRequest : '[Provide business requirement]') +
                          '\n\nCreate 5-8 user stories following this structure:\n' +
                          '- As a [persona], I want [feature] so that [benefit]\n' +
                          '- Acceptance criteria (3-5 items)\n' +
                          '- Story points estimate\n' +
                          '- Dependencies\n' +
                          '- Technical considerations\n\n' +
                          'Format as JSON array of story objects.';

        return new PromptTemplate(systemContext, userPrompt, 3000);
    }

    /**
     * @description Get the prompt template for test case generation
     * @param userRequest The feature or user story to test
     * @return PromptTemplate Complete prompt template ready for AI
     */
    public static PromptTemplate getTestCasePrompt(String userRequest) {
        String systemContext = 'You are a QA Engineer with expertise in Salesforce testing. ' +
                             'You create comprehensive test cases covering positive, negative, and edge cases.';

        String userPrompt = 'Generate test cases for the following feature:\n\n' +
                          (String.isNotBlank(userRequest) ? userRequest : '[Provide feature description]') +
                          '\n\nInclude:\n' +
                          '- Positive test scenarios\n' +
                          '- Negative test scenarios\n' +
                          '- Boundary conditions\n' +
                          '- Integration test scenarios\n' +
                          '- Security test cases\n\n' +
                          'Format as JSON array with: testId, scenario, steps, expectedResult, priority.';

        return new PromptTemplate(systemContext, userPrompt, 3500);
    }

    /**
     * @description Get the prompt template for executive status report
     * @param userRequest Project context or specific status items
     * @return PromptTemplate Complete prompt template ready for AI
     */
    public static PromptTemplate getExecutiveStatusPrompt(String userRequest) {
        String systemContext = 'You are a Program Manager skilled at creating executive-level status reports. ' +
                             'Your reports are concise, highlight key metrics, and focus on decision-making information.';

        String userPrompt = 'Create an executive status report for:\n\n' +
                          (String.isNotBlank(userRequest) ? userRequest : '[Provide project context]') +
                          '\n\nInclude:\n' +
                          '- Executive summary (2-3 sentences)\n' +
                          '- Project health status (Red/Yellow/Green)\n' +
                          '- Key accomplishments\n' +
                          '- Current risks and issues\n' +
                          '- Upcoming milestones\n' +
                          '- Budget status\n' +
                          '- Decisions needed\n\n' +
                          'Format as structured JSON.';

        return new PromptTemplate(systemContext, userPrompt, 2500);
    }

    /**
     * @description Get the prompt template for RAID log generation
     * @param userRequest Project context
     * @return PromptTemplate Complete prompt template ready for AI
     */
    public static PromptTemplate getRAIDLogPrompt(String userRequest) {
        String systemContext = 'You are a Risk Manager with Salesforce project expertise. ' +
                             'You identify and categorize Risks, Assumptions, Issues, and Dependencies.';

        String userPrompt = 'Generate a RAID log for:\n\n' +
                          (String.isNotBlank(userRequest) ? userRequest : '[Provide project context]') +
                          '\n\nIdentify:\n' +
                          '- Risks (with likelihood and impact)\n' +
                          '- Assumptions (that need validation)\n' +
                          '- Issues (current blockers)\n' +
                          '- Dependencies (external and internal)\n\n' +
                          'For each item provide: description, category, severity, owner, mitigation/resolution.\n' +
                          'Format as structured JSON.';

        return new PromptTemplate(systemContext, userPrompt, 3000);
    }

    /**
     * @description Get the prompt template for customer meeting preparation
     * @param userRequest Meeting context and objectives
     * @return PromptTemplate Complete prompt template ready for AI
     */
    public static PromptTemplate getMeetingPrepPrompt(String userRequest) {
        String systemContext = 'You are a Client Engagement Manager preparing for a customer meeting. ' +
                             'You create thorough meeting materials including agenda, talking points, and Q&A prep.';

        String userPrompt = 'Prepare meeting materials for:\n\n' +
                          (String.isNotBlank(userRequest) ? userRequest : '[Provide meeting context]') +
                          '\n\nCreate:\n' +
                          '- Meeting agenda\n' +
                          '- Key talking points\n' +
                          '- Anticipated questions and answers\n' +
                          '- Demo plan (if applicable)\n' +
                          '- Success metrics to highlight\n' +
                          '- Decisions needed from customer\n' +
                          '- Follow-up action items\n\n' +
                          'Format as structured JSON.';

        return new PromptTemplate(systemContext, userPrompt, 2500);
    }

    /**
     * @description Get the prompt template for deployment checklist
     * @param userRequest Deployment context and scope
     * @return PromptTemplate Complete prompt template ready for AI
     */
    public static PromptTemplate getDeploymentChecklistPrompt(String userRequest) {
        String systemContext = 'You are a Release Manager for Salesforce deployments. ' +
                             'You create comprehensive deployment checklists following DevOps best practices.';

        String userPrompt = 'Create a deployment checklist for:\n\n' +
                          (String.isNotBlank(userRequest) ? userRequest : '[Provide deployment scope]') +
                          '\n\nInclude:\n' +
                          '- Pre-deployment tasks\n' +
                          '- Deployment steps (ordered)\n' +
                          '- Validation tasks\n' +
                          '- Rollback plan\n' +
                          '- Post-deployment verification\n' +
                          '- Communication plan\n' +
                          '- Smoke test scenarios\n\n' +
                          'Provide timeline estimates for each phase.\n' +
                          'Format as structured JSON.';

        return new PromptTemplate(systemContext, userPrompt, 3000);
    }

    /**
     * @description Wrapper class for a complete prompt template
     */
    public class PromptTemplate {
        public String systemContext { get; set; }
        public String userPrompt { get; set; }
        public Integer maxTokens { get; set; }

        public PromptTemplate(String systemContext, String userPrompt, Integer maxTokens) {
            this.systemContext = systemContext;
            this.userPrompt = userPrompt;
            this.maxTokens = maxTokens;
        }

        /**
         * @description Get the full prompt combining system and user context
         * @return String The complete prompt
         */
        public String getFullPrompt() {
            return this.systemContext + '\n\n' + this.userPrompt;
        }
    }
}
