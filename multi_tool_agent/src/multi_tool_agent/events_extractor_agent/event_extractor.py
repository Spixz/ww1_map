from google.adk.agents import LlmAgent, LoopAgent, SequentialAgent
from google.adk.tools import ToolContext, agent_tool
from pydantic import BaseModel, Field
from .events_tools import event_extractor_agent_tool
from config import GEMINI_2_FLASH


event_extractor_manager_agent = LlmAgent(
    name="EventExtractorAgent",
    model=GEMINI_2_FLASH,
    description="Extraits les événements",
    instruction="""
utilise le  event extractor_tool sans formater sa réponse.   
    """,
    output_key="extracted_events",
    tools=[
        agent_tool.AgentTool(agent=event_extractor_agent_tool, skip_summarization=True)
    ],
)
