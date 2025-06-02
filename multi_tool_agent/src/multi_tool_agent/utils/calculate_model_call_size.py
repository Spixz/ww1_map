from google.adk.agents.callback_context import CallbackContext
from google.adk.models import LlmRequest, LlmResponse
from typing import Optional


def display_context_size(contents, title: str):
    # Calculer la taille (en caractères et en bytes) de tout le prompt
    total_text = ""
    if contents:
        for index, content in enumerate(contents):
            print(f"{index} {content.role} - {content.parts}")
            if content.parts:
                for part in content.parts:
                    if part.text:
                        total_text += part.text

    char_count = len(total_text)
    byte_count = len(total_text.encode("utf-8"))

    print(title)
    print(f"→ Total content: {len(contents)}")
    print(f"→ Total chars: {char_count}")
    print(f"→ Total bytes: {byte_count}")


def calculate_req_size(
    callback_context: CallbackContext, llm_request: LlmRequest
) -> Optional[LlmResponse]:
    # display_context_size(llm_request.contents, "🧠 Avant réduction du contexte")

    context_limit = 8
    if llm_request.contents and len(llm_request.contents) >= context_limit:
        # print("CONDITION FONCTION")
        selected_req = llm_request.contents[-context_limit]
        # print(f"stop at {selected_req}")
        while (
            selected_req.role == "user"  # ! function reponse
            and selected_req.parts
            and selected_req.parts[0].function_response is not None
        ) or (
            selected_req.role == "model"  # ! function call
            and selected_req.parts
            and selected_req.parts[0].function_call is not None
        ):
            if context_limit + 1 > len(llm_request.contents):
                print("BREAK TO AVOID OVERFLOW")
                break
            context_limit += 1
            selected_req = llm_request.contents[-context_limit]
            # print(f"context limit + 1 = {context_limit}")
            # print(f"recuperer : ({selected_req.role}) {selected_req.parts}")
            # recupe le model function call + le message ou la fonction call precedan la function call
        llm_request.contents = llm_request.contents[-context_limit:]

    # display_context_size(llm_request.contents, "🧠 Après réduction du contexte")

    return None
