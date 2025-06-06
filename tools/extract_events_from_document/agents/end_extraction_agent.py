from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool, BaseTool

# from google.adk.agents.llm_agent import AfterToolCallback
from multi_tool_agent.events_extractor_manager_agent.tools.store_event_in_db import (
    store_events_in_db,
)
from multi_tool_agent.events_extractor_manager_agent.tools.exit_loop import exit_loop
from tools.extract_events_from_document.src.extract_events_from_document.config import ADVANCED_MODEL
from multi_tool_agent.utils.calculate_model_call_size import calculate_req_size


end_extraction_agent = LlmAgent(
    name="EndExtractionAgent",
    model=ADVANCED_MODEL,
    instruction="""Appel `exit_loop` si les conditions sont remplies
    
    **Si l'un des numéros de pages de `{page_interval}` est supérieur ou égal à `{total_doc_pages}`, appel le tool `exit_loop`.
""",
    description="Met fin à l'exraction des donnés si le document a été entièrement parcouru.",
    tools=[exit_loop],
    before_model_callback=calculate_req_size,
)
